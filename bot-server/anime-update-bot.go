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
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
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
	MGO_Database   = "animeUpdate"
	MGO_Collection = "YOUR_COLLECTION"
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
	router.POST("/AnimeUpdate/action", actionHandler)
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

//	x, err := ioutil.ReadAll(c.Request.Body)
//	if(err != nil){
//		panic(err)
//	}
//        log.Println("Postbody:" + string(x))
	
	
	token := c.PostForm("token")
	response_url := c.PostForm("response_url")
	team_id := c.PostForm("team_id")
	user_id := c.PostForm("user_id")
	
	if(token != env.TOKEN){
		c.String(http.StatusForbidden, "Access forbidden")
	} else {
		messageJSON := checkSuscribeJSON(team_id, user_id)
		sendMessageToSlackResponseURL(response_url, []byte(messageJSON.String()))		


	}
	
}
func actionHandler(c *gin.Context){
	c.String(http.StatusOK, "")
	payload := c.PostForm("payload")
	payloadJSON, _ := gabs.ParseJSON([]byte(payload))
	log.Println(payloadJSON.StringIndent("", "    "))
	response_url, _ := payloadJSON.Path("response_url").Data().(string)
	//user_name, _ := payloadJSON.Path("user.name").Data().(string)

	team_id, _ := payloadJSON.Path("team.id").Data().(string)
	user_id, _ := payloadJSON.Path("user.id").Data().(string)
	
	action_array,_ :=payloadJSON.Path("actions").Children()
	button_name, _ := action_array[0].Path("name").Data().(string)
	animeTitle, _ := payloadJSON.Path("callback_id").Data().(string)
	

	////DB
	session, err := mgo.DialWithInfo(&mgo.DialInfo{
		Addrs: Host,
		// Username: Username,
		// Password: Password,
		// Database: Database,
		// DialServer: func(addr *mgo.ServerAddr) (net.Conn, error) {
		// 	return tls.Dial("tcp", addr.String(), &tls.Config{})
		// },
	})
	if err != nil {
		panic(err)
	}
	defer session.Close()
	// Collection
	collection := session.DB(MGO_Database).C(team_id + ":" + user_id)
	if(button_name == "Subscribe" ){
		err = collection.Insert(bson.M{"title": animeTitle})
		if err != nil {
			panic(err)
		}
	} else {
		err = collection.Remove(bson.M{"title": animeTitle})
		if err != nil {
			panic(err)
		}
	}
	
	/////DB

	
//	messageJSON := gabs.New()
//	messageJSON.SetP(user_name + " clicked: " + action_array_name, "text")
//	messageJSON.SetP(false, "replace_original")
	//	log.Println(messageJSON.String())

	messageJSON := checkSuscribeJSON(team_id, user_id)

	sendMessageToSlackResponseURL(response_url, []byte(messageJSON.String()))
}
func sendMessageToSlackResponseURL(url string, message []byte){
	log.Println("POST to " + url)
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(message))
	req.Header.Set("Content-Type", "application/json")
	
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
}
func checkSuscribeJSON(team_id string, user_id string)( *gabs.Container ){
	///read list json
	dat, err := ioutil.ReadFile("../list.json")
	if err != nil{
		panic(err)
	}
	listJSON, err := gabs.ParseJSON(dat)
	listArray, _ := listJSON.Children()

	///CHECK DB
	session, err := mgo.DialWithInfo(&mgo.DialInfo{
		Addrs: Host,
		// Username: Username,
		// Password: Password,
		// Database: Database,
		// DialServer: func(addr *mgo.ServerAddr) (net.Conn, error) {
		// 	return tls.Dial("tcp", addr.String(), &tls.Config{})
		// },
	})
	if err != nil {
		panic(err)
	}
	defer session.Close()
	// Collection
	collection := session.DB(MGO_Database).C(team_id + ":" + user_id)

	



	
	///MAKE JSON
//	log.Printf("id: " + team_id + " " + user_id)
	messageJSON := gabs.New()
	messageJSON.SetP("以下是承皓肥宅最近在追的番，訂閱以獲得更新通知。", "text")
	messageJSON.SetP(true, "replace_original")
	messageJSON.Array("attachments")
	

	for _, child := range listArray {
		animeTitle := child.Path("title").Data().(string)

		animeJSON :=gabs.New()
		animeJSON.SetP(animeTitle, "title")
		animeJSON.SetP(child.Path("title").Data().(string), "callback_id")
		animeJSON.SetP("default", "attachment_type")
		animeJSON.SetP("#42f4b9","color")
		animeJSON.Array("actions")
		
		suscribeButton := gabs.New()
		count, err := collection.Find(bson.M{"title": animeTitle}).Count()
		if err != nil{
			panic(err)
		}
		if(count > 0){
			animeJSON.SetP("已訂閱", "text")
			suscribeButton.SetP("Unsubscribe", "name")
			suscribeButton.SetP("Unsubscribe", "text")
			suscribeButton.SetP("button", "type")
			suscribeButton.SetP("Unsubscribe", "value")
			suscribeButton.SetP("danger", "style")
		} else {
			suscribeButton.SetP("Subscribe", "name")
			suscribeButton.SetP("Subscribe", "text")
			suscribeButton.SetP("button", "type")
			suscribeButton.SetP("Subscribe", "value")
			suscribeButton.SetP("primary", "style")
		}

		animeJSON.ArrayAppendP(suscribeButton.Data(), "actions")
		
		messageJSON.ArrayAppendP(animeJSON.Data(), "attachments")
	}
	//log.Println(messageJSON.StringIndent("", "    "))
	return messageJSON

}
