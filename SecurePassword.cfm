<!---
LICENSE INFORMATION:
Copyright 2010, Cristian Costantini
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 
You may obtain a copy of the License at 
	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.
--->

<cfsetting enablecfoutputonly="true">

<cfprocessingdirective pageencoding="utf-8">

<cfif thisTag.executionMode IS "start">

<!--- default input name --->
<cfparam name="attributes.name"			type="String"	default="password" />

<cfparam name="attributes.id"			type="String"	default="password" />
<cfparam name="attributes.class" 		type="String"	default="" />

<cfparam name="attributes.type" 		type="String"	default="string" />

<cfparam name="attributes.size"			type="Numeric"	default="20" />
<cfparam name="attributes.maxlength" 	type="Numeric"	default="25" />


<!--- Default javascript --->
<cfsavecontent variable="js">
<cfoutput>
// define name space
it = {};
it.millemultimedia = {};
it.millemultimedia.SecurePassword ={};

// implement event manager for extend this tag
it.millemultimedia.EventManager = function(){

	var events = {};
	var listeners = {};
	
	this.addEvent = function( name ){
		
		if( exists( events, name) ){
			alert('Event has been registered');
		}else{
			events[ name ] = new Array();
		}
		
	};
	
	this.addListener = function( eventName, handler ){

		if( !exists( listeners, eventName) ){
			listeners[ eventName ] = new Array();	
		}
		
		listeners[ eventName ].push( handler );

	};
	
	this.fireEvent = function( eventName, event ){
	
		var i = 0;
		var r = null;
		
		if( !exists( events, eventName) ){
			alert('Event' + eventName + 'not exists!')
		}
		
		if( exists( listeners, eventName ) ){
			
			for( i in listeners[ eventName ]  ){
				r = listeners[ eventName ][ i ]( event );
			}
			
		}
		
		return r;
		
	}
	
	var exists = function( obj, name ){
		var r = false;
		
		if(obj[ name ]){
			r = true;
		}
		return r;		
	}
	
}

// validation function
it.millemultimedia.SecurePassword = function(){

	var eventManager = new it.millemultimedia.EventManager();
	//configure event manager
	eventManager.addEvent( 'passwordLow' );
	eventManager.addEvent( 'passwordWeak' );
	eventManager.addEvent( 'passwordMedium' );
	eventManager.addEvent( 'passwordStrong' );
	eventManager.addEvent( 'onkeyup' );
	
	this.getEventManager = function(){
		return eventManager;
	}

	this.validatePassword = function() {
	
		var strength = document.getElementById('strength');
		var strongRegex = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\W).*$", "g");
		var mediumRegex = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");
		var enoughRegex = new RegExp("(?=.{6,}).*", "g");
		var pwd = document.getElementById("#attributes.id#");
		
		if (pwd.value.length==0) {
			strength.innerHTML = '';
		} else if (false == enoughRegex.test(pwd.value)) {
			strength.innerHTML = '<div id="pwLow"></div>';
			eventManager.fireEvent( 'passwordLow' );
		} else if (strongRegex.test(pwd.value)) {
			strength.innerHTML = '<div id="pwStrong"></div>';
			eventManager.fireEvent( 'passwordStrong' );
		} else if (mediumRegex.test(pwd.value)) {
			strength.innerHTML = '<div id="pwMedium"></div>';
			eventManager.fireEvent( 'passwordMedium' );
		} else {
			strength.innerHTML = '<div id="pwWeak"></div>';
			eventManager.fireEvent( 'passwordWeak' );
		}
	
	}
}

// Create Object secure password tool
securePassword = new it.millemultimedia.SecurePassword();
</cfoutput>
</cfsavecontent>

<!--- Default css style --->
<cfsavecontent variable="css">
<cfoutput>
	##strength {
		width:200px;
		height:30px;
		background:##f5f5f5;
		border:##666666 solid 1px;
		margin-top:3px;
		margin-bottom:3px;
	}
	
	##strength ##pwStrong{
		width:100%;
		height:30px;
		background:green;
	}
	
	##strength ##pwMedium{
		width:75%;
		height:30px;
		background:yellow;
		border-right:##666666 solid 1px;
	}
	
	##strength ##pwWeak{
		width:50%;
		height:30px;
		background:red;
		border-right:##666666 solid 1px;
	}
	
	##strength ##pwLow{
		width:25%;
		height:30px;
		background:red;
		border-right:##666666 solid 1px;
	}
</cfoutput>
</cfsavecontent>

<cfparam name="attributes.css"	type="String"	default="#css#" />

<cfset attributes.css = '<style type="text/css">' & attributes.css & '</style>' />
<cfset js = '<script language="javascript">' & js & '</script>' />

<cfhtmlhead text="#attributes.css#" />
<cfhtmlhead text="#js#" />

<cfoutput>
	<input name="#attributes.name#" id="#attributes.id#" class="#attributes.class#" type="#attributes.type#" size="#attributes.size#" maxlength="#attributes.maxlength#" onkeyup="return securePassword.validatePassword();" />
	<div id="strength"></div>
</cfoutput>

</cfif>