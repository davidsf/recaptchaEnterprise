component {

	// Module Properties
	this.title 				= "recaptchaEnterprise";
	this.author 			= "David Sedeño";
	this.description 	= "Google Recaptcha Enterprise Module";

	function configure(){

		settings = {
      projectId  = '',
			apiBaseUrl = 'https://recaptchaenterprise.googleapis.com/v1/projects/',
      scriptUrl  = 'https://www.google.com/recaptcha/enterprise.js',
			siteKey    = "",
      apiKey     = "",
      score      = "0.7",
      referer    = ""
		};
	}
}
