/**
 * This CFC allows you to connect to the reCaptcha Enterprise service for rendering and validation
 */
component singleton accessors="true"{

	// DI
	property name="config"               inject="coldbox:modulesettings:recaptchaEnterprise";
	property name="inteceptorService"    inject="coldbox:interceptorService";

	/**
	* Google API Key
	*/
	property name="apiKey" 	default="";

	/**
	* Google site Key
	*/
	property name="siteKey" 	default="";

	/**
	* The project Google project api url
	*/
	property name="googleApiUrl" default="";

	/**
	 * Constructor
	 *
	 * @apiKey The google api key
	 * @siteKey The google site key
	 */
	RecaptchaService function init( siteKey="", apiKey="" ){

		variables.siteKey = arguments.siteKey;
		variables.apiKey = arguments.apiKey;

		return this;
	}

	/**
	 * Execute after DI completes
	 */
	function onDIComplete(){
		variables.siteKey = variables.config.siteKey;
		variables.apiKey  = variables.config.apiKey;
		variables.score   = variables.config.score;

		variables.googleApiUrl = variables.config.apiBaseUrl &
                             variables.config.projectId &
                             "/assessments?key=" &
                             variables.config.apiKey;
	}

	/**
	 * Validate the captcha
	 *
	 * @response The Response from the form
	 */
	boolean function isValid( string response ){
		var result = httpSend( response );

		var check = deserializeJSON( result.filecontent );

    if( !structKeyExists(check, "riskAnalysis") ){
      variables.inteceptorService.announce(
        state = 'onRecaptchaEnterpriseFail',
        data  = {
          checkResponse = check
        },
        asyncAll = true
      );

      return false;
    }

    if( check.riskAnalysis.score >= variables.score ){
      return true;
    } else {
      variables.inteceptorService.announce(
        state = 'onRecaptchaEnterpriseFail',
        data  = {
          checkResponse = check
        },
        asyncAll = true
      );

      return false;
    }
	}

	/**
	 * Send the HTTP request
	 *
	 * @response The Response from the form
	 */
	struct function httpSend( required string response ){
		var event = {
			"event": {
			"token": arguments.response,
			"siteKey": "#getSiteKey()#"
			}
		}

		var httpService = new http(
			method  = "post",
			url 	= variables.googleApiUrl,
			timeout = 10
		);

		httpService.addParam( type="header",    name="Content-Type", value="application/json");
		httpService.addParam( type="body", value=serializeJSON(event));
		if( !isEmpty(config.referer) ){
			httpService.addParam( type="header", name="referer", value=config.referer);
		}
		return httpService.send().getPrefix();
	}
}
