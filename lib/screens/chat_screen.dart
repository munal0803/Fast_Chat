import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
class ChatScreen extends StatefulWidget {
  static const String id ='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = Firestore.instance;
  final _auth =FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  FirebaseUser loggedInUser;
  String messageT;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async{
    try{
    final user =  await _auth.currentUser();
    if(user!=null){
      loggedInUser =user;
      print(loggedInUser.email);

    }}catch (e){
      print(e);
    }
  }
  void messageStream() async{
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.documents){
        print('message.data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder:(context,snapshot){
                  if(!snapshot.hasData){
                    return Center(
                      child:CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ) ,

                    );
                  }
                    final messages = snapshot.data.documents.reversed;
                    List<messagebubble>messageBubbles=[];
                    for(var message in messages){
                      final messageText =message.data['text'];
                      final messageSender =message.data['sender'];
                     final currentUser = loggedInUser.email;
                  if(currentUser==messageSender){

                  }
                      final messageBubble=messagebubble(
                        sender:messageSender,text:messageText,
                        isMe:currentUser==messageSender,
                      );
                      messageBubbles.add(messageBubble);

                    }
                    return Expanded(
                      child: ListView(
                       reverse: true,
                        children:messageBubbles,

                      ),
                    );

                },

            ),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageT=value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add(
                        {
                          'text':messageT,
                          'sender':loggedInUser.email,
                        }
                      );
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class messagebubble extends StatelessWidget {
  messagebubble({this.sender,this.text,this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child:Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
        Text(sender,style: TextStyle(
          color:Colors.black54,
          fontSize: 12.0,
        ),),
        Material(
          borderRadius:isMe? BorderRadius.only(topLeft: Radius.circular(30),bottomLeft:Radius.circular(30),bottomRight: Radius.circular(30)):BorderRadius.only(topRight: Radius.circular(30),bottomLeft:Radius.circular(30),bottomRight: Radius.circular(30)),
          elevation:5.0,
          color: isMe?Colors.lightBlueAccent:Colors.white,
          child: Padding(
            padding:EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: Text('$text',style:TextStyle(
              fontSize: 15,
              color: isMe?Colors.white:Colors.black54,
            ),),
          ),
        ),
      ],),

    );;
  }
}
