# PhaxMachine

## Quick Setup

### 1. Deploy PhaxMachine

#### The easy way (click this button):

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/phaxio/phax_machine)

You'll notice a number of fields that need to be populated (e.g. App Name and the Config Variables). Choose an App name, and populate the API credentials fields with your production [API credentials from Phaxio](https://console.phaxio.com/apiSettings).

Skip to section 2 below.

#### Or manually:

1. Install and configure the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli).
   Create an account if you do not already have one.
2. Clone this repository: `git clone https://github.com/phaxio/phax_machine.git && cd phax_machine`
3. Create the app on Heroku: `heroku create`
4. Set the required environment variables:
   - `heroku config:set PHAXIO_API_KEY=your_api_key`
   - `heroku config:set PHAXIO_API_SECRET=your_api_secret`
5. Deploy: `git push heroku master`

### 2. Configure Mailgun (we'll come back to the fields on Heroku soon):

1. Sign up for a [Mailgun](https://www.mailgun.com) account.
2. In the Mailgun console, choose the "Domains" tab, then click the "Add New Domain" button, and enter the subdomain where you want to receive fax emails. In these examples, I'm using `phaxmail.myapp.com`. If you don't want to configure your own domain, you can use the sandbox domain already in your Mailgun account, but you'll have to manually add permitted user emails for the domain on Mailgun. If you're using the sandbox domain, you can skip to step 4 below.
![Mailgun Domains Tab Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_domains_tab.png)
![Mailgun Add Domain Button Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_add_domain.png)
![Mailgun Add Domain Form Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_add_domain_form.png)
3. Verify your domain. Mailgun will provide you with straight-forward guides on how to do this with most common providers. This step may take some time.
![Mailgun Verify Domain Page Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_domain_verification.png)
4. On the [domains page](https://app.mailgun.com/app/domains), select the domain that you'll be using. (This can be the sandbox domain in your account which ends mailgun.org.)
5. In the Domain Information section, copy and paste the SMTP Hostname into the SMTP_HOST field on Heroku.
6. Next copy and past the Default SMTP Login from Mailgun into the SMTP_USER field on Heroku.
7. Copy and paste the Default Password from Mailgun into the SMTP_PASSWORD field on Heroku.
8. Use port 587 as the SMTP port, mark SMTP_TLS as true, and enter the email address you'd like the emails to come from in the SMTP_FROM field.
9. Click Deploy!
10. Once your domain at Mailgun has been verified, choose the "Routes" tab, then click the "Create a Route" button
![Mailgun Routes Tab Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_routes_tab.png)
![Mailgun Create Route Button Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_route_add_button.png)
11. On the "Create New Route" page, choose "Match Recipient" for the Expression Type, and in the Recepient field enter the following pattern (substituting the domain you previously configured): `[0-9]+@phaxmail.myapp.com`. Then, under "Actions", tick the "Forward" box and enter the URL for your instance of PhaxMachine, followed by `/mailgun` (e.g. If you're using a quick and dirty Heroku installation, this url might look something like https://WHATYOUNAMEDYOURAPP.herokuapp.com/mailgun.) The other fields should be left alone, and once you're finished click the "Create Route" button.
![Mailgun New Route Page Screenshot 1](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_new_route_1.png)
![Mailgun New Route Page Screenshot 2](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_new_route_2.png)
12. (Optional, only needed if you want to test that fax-to-email and email-to-fax are working) Open your instance of PhaxMachine, click on the "Manage Users" link at the top, and add create a user with your email and phaxio fax number.
13. (Optional) Test that everything is working correctly by sending an email with an attachment in the following format: `15551231234@phaxmail.myapp.com` (substituting the phone number and domain). **Phone Numbers should not contain any special characters.** If everything is set up correctly, you should have just sent a fax.
![Email Example](https://github.com/phaxio/phax_machine/raw/master/readme_assets/phaxio_email.png)

### Setting up Fax --> Email
1. Head to the [Callback URL's page in Phaxio](https://console.phaxio.com/user/callbacks/edit).
2. In the second field which says "POST (or send email) to the above URL when a fax has been received," enter your application url followed by '/fax_received' (e.g. If you're using a quick and dirty Heroku installation, this url might look something like https://WHATYOUNAMEDYOURAPP.herokuapp.com/fax_received. *Note:* if you're using the quick and dirty setup, your faxing emails might be in your spam folder! )

3. (Optional) Test the everything is working correctly by sending a fax to your Phaxio number and and seeing if it shows up in your email inbox! Note: make sure to check your spam folder!

## Updating an app deployed using the "Deploy" button

If you want to merge the latest code from this repository into a PhaxMachine instance deployed with
the button above, you'll need to follow these instructions:

1. Clone this repository: `git clone https://github.com/phaxio/phax_machine.git`
2. Add the heroku repository as well: `git remote add heroku https://git.heroku.com/HEROKU-APP-NAME.git` (Substituting `HEROKU-APP-NAME` with the name of your Heroku app)
3. Push the latest changes to Heroku: `git push heroku master`
