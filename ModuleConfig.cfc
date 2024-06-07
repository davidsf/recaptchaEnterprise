component {

	// Module Properties
	this.version 		= "1.2.0";
	this.title 		= "recaptchaEnterprise";
	this.author 		= "David Sedeño";
	this.description 	= "Google Recaptcha Enterprise Module";

	function configure(){

		interceptorSettings = {
			customInterceptionPoints = "onRecaptchaEnterpriseFail"
		};

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
