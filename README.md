# ColdBox ReCAPTCHA Enterprise Google Module

This module contains helpers for using Google's ReCAPTCHA Enterprise API.

reCAPTCHA Enterprise is a service that protects your site from spam and abuse. It uses advanced risk analysis techniques to tell humans and bots apart.

reCAPTCHA Enterprise returns a score for each request without user friction. The score is based on interactions with your site and enables you to take an appropriate action for your site. 

## LICENSE

Apache License, Version 2.0.

## SYSTEM REQUIREMENTS

- Lucee 5+
- ColdFusion 11+
- ColdBox 5+

## INSTRUCTIONS
Just drop into your `modules` folder or use the CommandBox to install

`box install recaptchaEnterprise`

## USAGE

### Settings

You need two API Keys: 

* Site Key: You need to create a project inside the reCAPTCHA Enteprise of your project in Google Cloud: https://console.cloud.google.com/security/recaptcha/ 

* API Key: A key with permission to access de reCAPTCHA Enterprise API. You can create in your API Credentials of your Google Cloud console of your project: https://console.cloud.google.com/apis/credentials

Also, you need the main Id of your project in Google Cloud.

With this two keys you can add the following settings to your `Coldbox.cfc` under a `recaptchaEnterprise` structure within the `moduleSettings` structure:

```js
moduleSettings = {
	// recaptcha enterprise settings
	recaptchaEnterprise = {
      projectId = "projectId"
    	siteKey 	= "Site key",
    	apiKey  	= "Api key",
      score     = "0.7", // Minimum score to consider good the session
      referer   = "www.example.com" // Domain configured in reCAPTCHA Enterprise
	};
}
```

### Rendering Recaptcha

In any form you wish to add the reCaptcha widget which is a button with the invisible reCaptcha embedded.

Here is an example of usage:

```html
#view(
	view="widget",
	module="recaptchaEnterprise",
	args={
		id = "button-id",
		label = "Your Label",
		class = "text-center",
		callbackFunction = "onSubmit",
		loadRecaptchaApi = "true"
	}
)#
```

The arguments the widget receives are the following arguments:
- `id` -> optional argument to set an id to the button so you can manipulate it via css/js
- `label` -> It can be any text you want and will be used as the label for your button.
- `class` -> The class that will be applied to the button element.
- `callbackFunction` -> The callback function to handle the token.
	```js
   function onSubmit(token) {
     document.getElementById("your-form-id").submit();
   }
	```

- `loadRecaptchaApi` -> a true/false flag (defaults to false) if you want to delegate the widget the task to load the javascript api, otherwise you will have to do it yourself in your layout like so:

```js
 < script src="https://www.google.com/recaptcha/enterprise.js?render=SITEKEY"></script>
 ```

### Validation

Validation can be done manually or using or custom validator that leverages the `cbValidation` module (https://forgebox.io/view/cbValidation).

### Custom Validator

In your handler for the post of the form, or in a model object you can then use the included Validator. Here is an example of using it in a model object:

```js
this.constraints = {
	"body" 	: { required : true },
	"recaptcha" : { validator: "Validator@recaptchaEnterprise" }
}
```

In the above example, your handler would just need to set the recaptcha property on the model object to the `g-recaptcha-response` value that is part of the form payload.

### Manual Validation

There also is a `RecaptchaService@recaptchaEnterprise` Wirebox mapping you can use to validate manually if you prefer to not use the `cbvalidation` integration. In your handler:

```js
var recaptchaOK = getInstance( "RecaptchaService@recaptchaEnterprise" ).isValid( rc[ "g-recaptcha-response" ] );

if ( !recaptchaOK ){
    writeOutput( "Prove you have a soul!" );
}
```
### Failed Checks Interceptor

The module announce the [custom event](https://coldbox.ortusbooks.com/the-basics/interceptors/custom-events) "onRecaptchaEnterpriseFail" and pass the struct of the response in data.checkResponse. This checkReponse is as follows:

```
{
 "event":{
    "expectedAction":"EXPECTED_ACTION",
    "hashedAccountId":"ACCOUNT_ID",
    "siteKey":"KEY_ID",
    "token":"TOKEN",
    "userAgent":"(USER-PROVIDED STRING)",
    "userIpAddress":"USER_PROVIDED_IP_ADDRESS"
 },
 "name":"ASSESSMENT_ID",
 "riskAnalysis":{
   "reasons":[],
   "score":"SCORE"
 },
 "tokenProperties":{
   "action":"USER_INTERACTION",
   "createTime":"TIMESTAMP",
   "hostname":"HOSTNAME",
   "invalidReason":"(ENUM)",
   "valid":(BOOLEAN)
 }
}
```

More info: https://cloud.google.com/recaptcha-enterprise/docs/interpret-assessment-website




### THANKS

This module is based in recaptcha3 module by Javier Quintero. 
