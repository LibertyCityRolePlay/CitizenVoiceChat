
let voicedata = [];
$(function()
{
  $('#micro').hide();
  $('#loginmincto').hide();
  let Timer = function(callback, delay) {
    var timerId, start, remaining = delay;

    this.pause = function() {
        window.clearTimeout(timerId);
        remaining -= Date.now() - start;
    };

    this.delete = function() {
        window.clearTimeout(timerId);
    };

    this.resume = function() {
        start = Date.now();
        window.clearTimeout(timerId);
        timerId = window.setTimeout(callback, remaining);
    };

    this.resume();
};


var verr = false;
var peer;

navigator.getUserMedia = ( navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia ||navigator.msGetUserMedia);

let myid = -1;
let securyid = "coopds";
var glovalvoice;

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
}

Messageslogs("Загрузка скрипта");

var obj = {};
obj = { cmd: 'start' };
$.post('http://voicechat/goodload', JSON.stringify(obj), function(data)
{
    Messageslogs(data);
});

/*Test Eveys */
myid = 1234;
securyid = "AAAA";
Messageslogs("pID: "+myid);
Messageslogs("Encryption key gKey: "+securyid);
StartPeer();
StartLocalVoice();
ConnectTo(123, "AA");

/*=================*/

function Messageslogs(inpt)
{
  console.log(inpt);
}

function displayArgumentsArray(...theArguments) {
    Messageslogs(theArguments);
}

function StartPeer()
{
}
function StartLocalVoice()
{
  Messageslogs("Connect to server with pID:" + myid + " gKey: " + securyid)
    peer = new Peer(myid+""+securyid, {
      config: {'PeerJS Server': [
      { url: 'IP:PORT/myapp' }
      ]} 
    });
    Messageslogs("Launches wiretapping:" + myid)
    peer.on('open', function(id) {
        
      Messageslogs("Wiretapping started! "+id);
      $('#micro').show();
        peer.on('call', function(call) {
            
            Messageslogs("The player has connected to us.");
            navigator.getUserMedia({video: false, audio: true}, function(stream) {
                stream.getAudioTracks()[0].enabled = true;
                 


                call.answer(stream); 
                call.on('stream', function(remoteStream) {
                    Messageslogs("Player connecting to ME succ");
                    
                    Messageslogs("The player has connected to us. (Successfully)");
                });
            }, function(err) {
                Messageslogs("Microphone not found!");
                var img = document.getElementById("micro"); 
                img.src = 'error.png'; 
            });
        });
    });
}

var tim = new Array();
var tims = new Array();
function ConnectTo(playerid, playername)
{
  try
  {
    Messageslogs("rID: " + playerid + ", pId: " + myid);
    if(playerid != myid && myid != -1)
    {
      var vledid = document.getElementById("voicer_"+playerid);
      if(vledid)
      {
        return;
      }
      Messageslogs("Trying to connect to " + playerid);
        navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
        navigator.getUserMedia({video: false, audio: true}, function(stream) {
            Messageslogs("Connect to" + playerid);
            tims[playerid] = 1;
            tim[playerid] = new Timer(function() {
              if(tims[playerid] >= 3)
              {
                Messageslogs("Trying to reconnect to" + playerid);
                //tims[playerid] += 1;
                ConnectTo(playerid, playername);
              }
              
            }, 5000);
            var call = peer.call(playerid+""+securyid, stream);
            
            call.on('stream', function(remoteStream) {
              
                Messageslogs("Launched new Audio stream for player pID: " + playerid);
               
                var newwlements = document.createElement('audio');
                newwlements.id = "voicer_" + playerid;
                
                document.getElementById('audblocks').appendChild(newwlements);
                newwlements.srcObject = remoteStream;
                newwlements.controls = 'controls';
                newwlements.autoplay = '';
                newwlements.volume = 1.0;
                newwlements.style.opacity = "0.0";
                newwlements.pause();
               
                let namepla = playername;
                namepla = namepla.toUpperCase();
                namepla = namepla.replace('_', ' ');
                var brevuilceui = document.createElement('p')
                brevuilceui.id = "voiceui_"+playerid;
                brevuilceui.style.fontFamily = "'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif";
                brevuilceui.style.fontSize = "1.5vh";
                brevuilceui.innerText = ""+namepla;
                brevuilceui.style.textAlign = "center";
                brevuilceui.style.color = "#78d85d";
                brevuilceui.style.backgroundColor = "rgba(0, 0, 0, 0.418)";
                brevuilceui.style.padding = "5px";
                document.getElementById('audui').appendChild(brevuilceui);

                $("#voiceui_"+playerid).hide();
                var vid = document.getElementById("voicer_"+playerid);
                if(!vid)
                {
                  tim[playerid] = new Timer(function() {
                    if(tims[playerid] >= 3)
                    {
                      Messageslogs("Trying to reconnect to pID:" + playerid);
                     
                      ConnectTo(playerid, playername);
                    }
                    
                  }, 5000);
                  
                }
                vid.volume = 1.0;  
                
                Messageslogs("Successfully connected to pID:"+playerid+"!");
                tim[playerid].delete();
            });
            }, function(err) {
                Messageslogs("Microphone not found!");
                var img = document.getElementById("micro"); 
                img.src = 'error.png'; 
        });
    }
  }
  catch(e)
  {
    Messageslogs("[VoicePeer] " + e);
  }
    
    

}

window.addEventListener('message', function(event)
{
    var item = event.data;
    
    if (item.meta && item.meta == 'setstatusvoiceradio')
    { 
      
        if(item.volume == 1)
        {

          Messageslogs("+#voiceui_"+item.player);
          document.getElementById('voicer_'+item.player).play();
          $("#voiceui_"+item.player).show();
          Messageslogs("++#voiceui_"+item.player);
          
        }
        else
        {
          Messageslogs("-#voiceui_"+item.player);
          document.getElementById('voicer_'+item.player).pause();
          $("#voiceui_"+item.player).hide();
          Messageslogs("--#voiceui_"+item.player);
        }
        
        return;
    }
    if (item.meta && item.meta == 'setstatusvoice')
    { 
      var tempplayer = document.getElementById('voicer_'+item.player);
      if(tempplayer != null)
      {
        Messageslogs("ChangeVolume");
        if(item.volume === 1)
        {
          if(voicedata[item.player] <= 0.1)
          {
            document.getElementById('voicer_'+item.player).pause();
            $("#voiceui_"+item.player).hide();
          }
          else
          {
            Messageslogs("Pla");
            document.getElementById('voicer_'+item.player).play();
            $("#voiceui_"+item.player).show();
          }
        }
        else
        {
          document.getElementById('voicer_'+item.player).pause();
          $("#voiceui_"+item.player).hide();
        }
      }
      
        
      return;
    }
    if (item.meta && item.meta == 'deletevoiceuser')
    { 
      document.getElementById('voicer_'+item.player).remove();
        
      return;
    }
    if (item.meta && item.meta == 'adduser')
    { 
      if(document.getElementById('voicer_'+item.db) == null)
      {
        Messageslogs("2 - Connect to " + item.name);

        ConnectTo(item.db, item.name);
      }
        
      return;
    }
    if (item.meta && item.meta == 'voiceonr')
    { 

      var img = document.getElementById("micro"); 
      img.src = 'onr.png'; 
      return;
    }

    if (item.meta && item.meta == 'voiceon')
    { 
      if(verr == false)
      {
          var img = document.getElementById("micro"); 
          img.src = 'on.png'; 
      }
      
      
      return;
    }
    if (item.meta && item.meta == 'setvolumeplayer')
    { 
      var tempplayer = document.getElementById('voicer_'+item.player);
      if(tempplayer != null)
      {
        if(item.volume == -1)
        {
          tempplayer.volume = 0.0;
        }
        else
        {
          tempplayer.volume = ((100 - (item.volume*100/30))/100);
        }
        
      } 

        return;
    }

    if (item.meta && item.meta == 'voiceoff')
    { 
      if(verr == false)
      {
          var img = document.getElementById("micro"); 
          img.src = 'off.png'; 
      }
      
      
      return;
    }

    if (item.meta && item.meta == 'activeloginmicro')
    { 
      $('#loginmincto').show();
      return;
    }

    if (item.meta && item.meta == 'getmyids')
    { 
      myid = item.smyid;
      securyid = item.secure;
      Messageslogs("pID: "+myid);
      Messageslogs("Encryption key gKey: "+securyid);
      StartPeer();
      StartLocalVoice();
      return;
    }
    
}, false);

function refetchData()
{
    getLock = 0;

    $.get('http://voicechat/getstatus', function(data)
    {
        if (getLock > 1)
        {
            setTimeout(refetchData, 50);

            return;
        }

        getLock++;

        data.forEach(function(item)
        {
            
            
        });
    });
}

window.addEventListener('message', function(event)
{
    if (event.data.type != 'poll')
    {
        return;
    }

    refetchData();
}, false);
});