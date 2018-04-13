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
	//"strings"
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
	router.POST("/AnimeUpdate/eat-my-update", sendUpdateHandler)
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

	log.Println("code:" + code)
	client := &http.Client{}
	req, err := http.NewRequest("GET", "https://slack.com/api/oauth.access?code="+code+
		"&client_id="+env.CLIENT_ID+
		"&client_secret="+env.CLIENT_SECRET+
		"&redirect_uri="+env.REDIRECT_URL, nil)
	req.Header.Set("content-type","application/x-www-form-urlencoded")
	response, _ := client.Do(req)
       
        if err != nil {
                panic(err)
        } else {
                defer response.Body.Close()
		bodyBytes, _ := ioutil.ReadAll(response.Body)
		JSONresponse, err := gabs.ParseJSON(bodyBytes)
                if err != nil {
			log.Println("ERROR response!")
			log.Println(JSONresponse.StringIndent("", "    "))
                        panic(err)
                } else {
			if(JSONresponse.Path("ok").Data().(bool) == true){
				log.Println("Success!")
				log.Println(JSONresponse.StringIndent("", "    "))
				c.String(http.StatusOK, "OK! Thanks for using anime-updater")
				team_id := JSONresponse.Path("team_id").Data().(string)
				access_token := JSONresponse.Path("access_token").Data().(string)
				bot_token := JSONresponse.Path("bot.bot_access_token").Data().(string)
				//log.Println(team_id + access_token)

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
				collection := session.DB(MGO_Database).C(team_id)
				collection.RemoveAll(nil)
				err = collection.Insert(bson.M{
					"access_token": access_token,
					"has_token":true,
					"bot_token": bot_token})
				if err != nil {
					panic(err)
				}
				
				/////DB

			}else {
				log.Println("ERROR response!")
				log.Println(JSONresponse.StringIndent("", "    "))
				c.String(http.StatusOK, "ERROR response, see the log!")
			}
		}
	}



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

	log.Println(team_id + " : " + user_id)
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
	collection := session.DB(MGO_Database).C(team_id)
	if(button_name == "Subscribe" ){
		Who := bson.M{"User_id": user_id}
		PushToArray := bson.M{"$push": bson.M{"Anime": animeTitle}}
		collection.Update(Who, PushToArray)
		
	} else {
		Who := bson.M{"User_id": user_id}
		PullFromArray := bson.M{"$pull": bson.M{"Anime": animeTitle}}
		collection.Update(Who, PullFromArray)
		
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
func sendUpdateHandler(c *gin.Context){
	

	animeTitle := c.PostForm("title")
	attachText := c.PostForm("data")

	log.Println("收到訊息啦！" + animeTitle)
	log.Println("data: " + attachText)
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
	//每個Team
	//每個User
	//如果有訂閱這animeTitle
	//送通知
	// Collection
	teams, _ := session.DB(MGO_Database).CollectionNames()
	for _, team := range(teams){
		if(team == "system.indexes"){
			continue
		}
		//log.Println("teamsNames: " + team)
		collection := session.DB(MGO_Database).C(team)
		//拿token
		type AccessToken struct{
			ID bson.ObjectId `bson:"_id,omitempty"`
			Access_token string "access_token"
			Has_token bool "has_token"
			Bot_token string "bot_token"
		}
		tokenData := AccessToken{}
		err = collection.Find(bson.M{"has_token": true}).One(&tokenData)
		if(err != nil){
			panic(err)
		}
		//log.Println(tokenData.Access_token)
		//Get channelID
		JSONresponse := gabs.New()
		client := &http.Client{}
		req, err := http.NewRequest("GET", "https://slack.com/api/im.list?token=" + tokenData.Bot_token, nil)
		req.Header.Set("content-type","application/x-www-form-urlencoded")
		response, _ := client.Do(req)
		if err != nil {
			panic(err)
		} else {
			defer response.Body.Close()
			bodyBytes, _ := ioutil.ReadAll(response.Body)
			JSONresponse, err = gabs.ParseJSON(bodyBytes)
			if err != nil {
				log.Println("ERROR response!")
				log.Println(JSONresponse)
				panic(err)
			} else {
				log.Println("Success!")
				log.Println(JSONresponse.StringIndent("", "   "))
				c.String(http.StatusOK, "")
			}
		}

		//user名單
		var users []User_doc
		err = collection.Find(bson.M{"has_token": false}).All(&users)
		if err != nil {
			panic(err)
		}
		for _, user := range users{
			//在imlist中找user的channel id
			channel_id := ""
			imsArray, _ := JSONresponse.Path("ims").Children()
			for _, ims_child := range(imsArray){
				if(ims_child.Path("user").Data().(string) == user.User_id){
					channel_id = ims_child.Path("id").Data().(string)
				}
			}
			//確認有沒有訂閱
			found := false
			for _, t := range user.Anime{
				if t == animeTitle{
					found = true
					break
				}
			}
			if(found){
				//送通知
				log.Println("送通知：" + animeTitle)
				messageJSON := gabs.New()
				messageJSON.SetP(channel_id, "channel")
				messageJSON.SetP(false, "as_user")
				//messageJSON.SetP(animeTitle, "text")
				messageJSON.SetP(attachText, "attachments")
				req, err := http.NewRequest("POST", "https://slack.com/api/chat.postMessage", bytes.NewBuffer([]byte(messageJSON.String())))
				req.Header.Set("Content-Type", "application/json")
				req.Header.Set("Authorization", "Bearer " + tokenData.Access_token)
				//client := &http.Client{}
				resp, err := client.Do(req)
				if err != nil {
					panic(err)
				}
				defer resp.Body.Close()
				bodyBytes, _ := ioutil.ReadAll(resp.Body)
				//log.Println("respBidy: " + string(bodyBytes))
				sendResp, err := gabs.ParseJSON(bodyBytes)
				if err != nil {
					log.Println("ERROR response!")
					log.Println(sendResp.StringIndent("", "   "))
					panic(err)
				} else {
					log.Println("Success!")
					log.Println(sendResp.StringIndent("", "   "))
					c.String(http.StatusOK, "")
				}
			}
			
		}
		
	}



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
	collection := session.DB(MGO_Database).C(team_id)
	
	///確認是否有此使用者
	count, err := collection.Find(bson.M{"User_id": user_id}).Count()
	if err != nil {
		panic(err)
	}
	if(count == 0){
		collection.Insert(bson.M{"User_id": user_id, "has_token":false})
	}

	//查詢使用者訂閱清單
	//若在陣列中找到則...
	user_doc1 := User_doc{}
	err = collection.Find(bson.M{"User_id": user_id}).One(&user_doc1)
	if err != nil{
		panic(err)
	}
	
	
	
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

		found := false
		for _, childAni := range user_doc1.Anime {
			if(animeTitle == childAni){
				found = true
				break
			}
		}
		if(found){
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
type User_doc struct{
	ID bson.ObjectId `bson:"_id,omitempty"`
	User_id string "User_id"
	Anime []string "Anime"
	Has_token bool "has_token"
}
