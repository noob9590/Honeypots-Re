# Honeypots-Re

<h3>Brief<br/></h3>
Honeypots-Re is a research project about the optional ways to deploy honeypots in an organization network.<br/>
The project includes three main programs:<br/>
1) Web interface<br/>
2) Agent for honeypots detection via windows event log<br/>
3) Agent for updating users that used to be honeypots for an attacker<br/>


<h3>Installing Web Application<br/></h3>
1.Clone the project <br/>
2.Navigate to frontend folder and build the react app with the command "npm run build"


<h3>Installing Server Side<br/></h3>
1.Create env file for storing the following information<br/>
USER_NAME="Web application username"<br/>
PASSWORD="Web application username's password"<br/>
ACCESS_TOKEN="AES 256 encryption string"<br/>
USER_ID="what ever ID you want"<br/>
DB_CONNECTION=mongodb+srv://"your mongodb account information"<br/>
2.Create self certificate - here is a tutorial: https://windowsreport.com/create-self-signed-certificate/<br/>
3.Create folder named security2 in the backend folder and drop the .Pem files over there<br/>
4.Copy the build folder from the frontend folder to the backend folder<br/>
5.run the command "npm start" in the cmd<br/>
6.open https://localhost:3002 in your browser


<h3>honeypot detection agent<br/></h3>
This agent has 2 commands<br/>
1.python main.py --start=configuration <br/>
You can use this command in order to eneter the configuration to detect the windows event logs.<br/>
2.If you do have a file with configuration in the correct format use the command "python main.py -f YOURFILENAME.txt<br/>
For additional information run the command "python main.py -h"<br/>

Soon as you run all the programs you can see the windows event logs showing in your web browser
