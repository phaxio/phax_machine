# PhaxMachine

## Quick Setup

### 1. Deploy PhaxMachine

#### The easy way (click this button):

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

#### Or manually:

1. Install and configure the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli).
   Create an account if you do not already have one.
2. Clone this repository: `git clone https://github.com/phaxio/phax_machine.git && cd phax_machine`
3. Create the app on Heroku: `heroku create`
4. Set the required environment variables:
   - `heroku config:set PHAXIO_API_KEY=your_api_key`
   - `heroku config:set PHAXIO_API_SECRET=your_api_secret`
5. Deploy: `git push heroku master`

### 2. Configure Mailgun

1. Sign up for a [Mailgun](https://www.mailgun.com) account.
2. In the Mailgun console, choose the "Domains" tab, then click the "Add New Domain" button, and enter the subdomain where you want to receive fax emails. (In these examples, I'm using `phaxmail.myapp.com`)
![Mailgun Domains Tab Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_domain_tabs.png)
![Mailgun Add Domain Button Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_add_domain.png)
![Mailgun Add Domain Form Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_add_domain_form.png)
3. Verify your domain. Mailgun will provide you with straight-forward guides on how to do this with most common providers. This step may take some time.
![Mailgun Verify Domain Page Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_domain_verification.png)
3. Once your domain has been verified, choose the "Routes" tab, then click the "Create a Route" button
![Mailgun Routes Tab Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_routes_tab.png)
![Mailgun Create Route Button Screenshot](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_route_add_button.png)
4. On the "Create New Route" page, choose "Match Recipient" for the Expression Type, and enter the following pattern (substituting the domain you previously configured): `[0-9]+@phaxmail.myapp.com`. Then, under "Actions", tick the "Forward" box and enter the URL for your instance of PhaxMachine, followed by `/mailgun`. The other fields should be left alone, and once you're finished go ahead and click the "Create Route" button.
![Mailgun New Route Page Screenshot 1](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_new_route_1.png)
![Mailgun New Route Page Screenshot 2](https://github.com/phaxio/phax_machine/raw/master/readme_assets/mailgun_new_route_2.png)
5. (Optional) Test that everything is working correctly by sending an email with an attachment in the following format: `15551231234@phaxmail.myapp.com` (substituting the phone number and domain). **Phone Numbers should not contain any special characters.** If everything is set up correctly, you should have just sent a fax.
![Email Example](https://github.com/phaxio/phax_machine/raw/master/readme_assets/phaxio_email.png)
