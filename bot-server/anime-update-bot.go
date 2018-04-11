package main

import(
	//"html/template"
	"log"
	"io/ioutil"
	"net/http"
	"github.com/gin-gonic/gin"
	"github.com/gin-contrib/cors"
	//"github.com/gorilla/websocket"
	// "encoding/json"
	//"strconv"
//	"os"
//	"path/filepath"
//	"gopkg.in/mgo.v2"
	//	"gopkg.in/mgo.v2/bson"
	"github.com/Jeffail/gabs"
	"bytes"
)
/////const for MONGODB.
var Host = []string{
	"127.0.0.1:27017",
	// replica set addrs...
}
const (
	Username   = "YOUR_USERNAME"
	Password   = "YOUR_PASS"
	Database   = "animeUpdate"
	Collection = "YOUR_COLLECTION"
)
/////
type environment struct{
	CLIENT_ID string
	CLIENT_SECRET string
	TOKEN string
	REDIRECT_URL string
}
var env = environment{}
func main(){
	dat, err := ioutil.ReadFile("./info.json")
	if err != nil{
		panic(err)
	}
	jsonParsed, err := gabs.ParseJSON(dat)
	value, _ := jsonParsed.Path("client-id").Data().(string)
	env.CLIENT_ID = value
	value, _ = jsonParsed.Path("client-secret").Data().(string)
	env.CLIENT_SECRET = value
	value, _ = jsonParsed.Path("token").Data().(string)
	env.TOKEN = value
	value, _ = jsonParsed.Path("redirect-url").Data().(string)
	env.REDIRECT_URL = value
	log.Println(env)

	
	router := gin.Default()
	//router.GET("/ws/MusicPlayer", func(c *gin.Context){wshandler(c.Writer, c.Request)})
	//router.Use(cors.Default())
	config := cors.DefaultConfig()
	config.AllowAllOrigins = true
	config.AllowMethods = []string{"GET", "POST", "DELETE"}
	router.Use(cors.New(config))
	
	router.StaticFile("/AnimeUpdate/auth/add_to_slack.html", "./web/add_to_slack.html")
	router.GET("/AnimeUpdate/auth/redirect", redirectHandler)
	router.POST("/AnimeUpdate/slash-command/anime-updater", sendButtonHandler)
	/////MONGOBD
//	router.GET("/MusicServer/songlist", showSongListHandler)
//	router.GET("/MusicServer/songlist/:listname", singleSongListHandler)
//	router.POST("/MusicServer/songlist", addToSongListHandler)
//	router.POST("/MusicServer/songquery", songQueryHandler)
//	router.DELETE("/MusicServer/songlist", deleteSongHandler)
	/////


	router.Run(":8027")
	log.Println("Serveing on 8027")
}
func redirectHandler(c *gin.Context){
	code := c.Query("code")
	response, err := http.Get("https://slack.com/api/oauth.access?code="+code+
		"&client_id="+env.CLIENT_ID+
		"&client_secret="+env.CLIENT_SECRET+
		"&redirect_uri="+env.REDIRECT_URL)
        if err != nil {
                panic(err)
        } else {
                defer response.Body.Close()
                //_, err := io.Copy(os.Stdout, response.Body)
		bodyBytes, _ := ioutil.ReadAll(response.Body)
		JSONresponse, err := gabs.ParseJSON(bodyBytes)
                if err != nil {
			log.Println("ERROR response!")
			log.Println(JSONresponse)
                        panic(err)
                } else {
			log.Println("Success!")
			log.Println(JSONresponse)
			c.String(http.StatusOK, "OK! Thanks for using anime-updater")
		}
	}
//	c.JSON(http.StatusOK, list)

}
func sendButtonHandler(c *gin.Context){
	c.String(http.StatusOK, "")
	token := c.PostForm("token")
	response_url := c.PostForm("response_url")
	if(token != env.TOKEN){
		c.String(http.StatusForbidden, "Access forbidden")
	} else {
		message := []byte(`{
            "text": "This is your first interactive message",
            "attachments": [
                {
                    "text": "Building buttons is easy right?",
                    "fallback": "Shame... buttons aren't supported in this land",
                    "callback_id": "button_tutorial",
                    "color": "#3AA3E3",
                    "attachment_type": "default",
                    "actions": [
                        {
                            "name": "yes",
                            "text": "yes",
                            "type": "button",
                            "value": "yes"
                        },
                        {
                            "name": "no",
                            "text": "no",
                            "type": "button",
                            "value": "no"
                        },
                        {
                            "name": "maybe",
                            "text": "maybe",
                            "type": "button",
                            "value": "maybe",
                            "style": "danger"
                        }
                    ]
                }
            ]
        }`)
		sendMessageToSlackResponseURL(response_url, message)
	}
	
}
func sendMessageToSlackResponseURL(url string, message []byte){
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(message))
	req.Header.Set("Content-Type", "application/json")
	
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
}
