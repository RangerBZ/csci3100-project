# Campus Trade

## Project Overview

Campus Trade is a secondhand trading website for the Chinese University of Hong Kong community.

## Team

| Name | Student ID | GitHub Username |
| --- | --- | --- |
| `HUANG Ruilin` | `1155211049` | `cuhk11049` |
| `BING Zhe` | `1155210946` | `Ranger-BZ` |
| `LI Xiaodong` | `1155211265` | `derekli-114` |
| `ZHANG Beichen` | `1155211153` | `bczhang2005` |
| `ZHU Ruizheng` | `1155210937` | `CCCCOrz` |

## Setup Guide

### 1. Prerequisites

Make sure the following are installed on your machine:

- Ruby `3.3.8`
- Bundler
- PostgreSQL
- Redis


### 2. Clone the Repository

```bash
git clone https://github.com/RangerBZ/csci3100-project.git
cd csci3100-project
```

### 3. Install Dependencies

```bash
bundle install
```

### 4. Configure Environment Variables

Create a `.env` file in the project root and fill in the required values.

Example:

```env
DB_USERNAME=your_postgres_username
DB_PASSWORD=your_postgres_password
SENDGRID_API_KEY=your_sendgrid_api_key
MAPBOX_TOKEN=your_mapbox_token
ADMIN_PASSWORD=your_admin_password
```

Notes:

- `DB_USERNAME` and `DB_PASSWORD` are required for PostgreSQL.
- `SENDGRID_API_KEY` is needed for the password reset email feature.
- `MAPBOX_TOKEN` is needed for the location map pages.
- `ADMIN_PASSWORD` is used by the seeded admin account in development/test.

### 5. Prepare the Database

```bash
bin/rails db:prepare
bin/rails db:seed
```

The seeded data includes:

- sample users
- sample item listings
- CUHK-related locations
- a development/test admin account

### 6. Start Required Services

Start Redis in a separate terminal:

```bash
redis-server
```

Start Sidekiq in another terminal if you want background jobs and scheduled jobs:

```bash
bundle exec sidekiq
```

### 7. Run the Application

```bash
bin/dev
```

If `bin/dev` is unavailable in your environment, you can also run:

```bash
bin/rails server
```

Then open:

```text
http://localhost:3000
```

## Test Guide

### Run the automated tests

Run Rails tests:

```bash
bin/rails test
```

Run Cucumber features:

```bash
bundle exec cucumber
```

`TODO:` If your team also used RSpec examples in practice, add the exact command here.


## Implemented Features

The table below summarizes the features currently implemented in the codebase. Please replace the owner fields with the actual teammate names.

| Feature | Description | Primary Contributor | Other Contributors |
| --- | --- | --- | --- |
| Basic CRUD Feature | Main menu + Item display + Post item + Edit user profile + Naive purchase and reserve function | `LI Xiaodong` | `BING Zhe` |
| Account Register and Login, Control Logic | Register with name, email, location and password; Login with name and password, reset password etc. | `LI Xiaodong` | `BING Zhe` |
| Search and Filtering | Search by keyword and filter by category, status, seller location, price range, and recent posting days | ``HUANG Ruilin`` | `[Fill in]` |
| Favorite Systems | Add to/Remove from favorites, and view favorite list | `ZHANG Beichen` | `HUANG Ruilin` |
| PostgreSQL Database | Resolve migration, PostgreSQL connection | `[Fill in]` | `[Fill in]` |
| Advanced Feature: Analytics | View charts and summaries for listing activity, categories, status, pricing, and community activity | `HUANG Ruilin` | `[Fill in]` |
| Advanced Feature: Search | Fuzzy search, Auto-complete | `HUANG Ruilin` | `[Fill in]` |
| Advanced Feature: external APIs | Mapbox for location maps, SendGrid email verification | `BING Zhe` | `N.A` |
| Advanced Feature: Sidekiq/Redis | Sidekiq/Redis for background jobs and scheduled tasks | `ZHANG Beichen` | `[Fill in]` |
| Cucumber tests | Cucumber tests in folder "features", including _steps.rb (except for web_steps.rb) and all .features files | `ZHU Ruizheng` | `[Fill in]` |
| RSpec tests | RSpec tests for controllers and models | `ZHU Ruizheng` | `[Fill in]` |


## SimpleCov Report Screenshots

```
SimpleCov Report Path for Rspec: docs/coverage1.png
SimpleCov Report Path for Cucumber: docs/coverage2.png
```


## Demo / Deployment

- Demo URL: <https://csci3100-proj.onrender.com/>
- Demo video: `[Fill in]`

## Side notes
- The SendGrid API offcial sending requires a formal domain name, this project only uses single sender API, so it comes from personal .gmail address. Possibly needs to look up in trash mail folder. Email send might take up to 5 minutes.
- Access to the Sidekiq dashboard (for background job monitoring) is strictly restricted to Admin users only. Regular users are denied access to ensure system security and prevent unauthorized operation monitoring.
- Users can choose to purchase or reserve items. Once they have reserved an item, it could not be purchased or reserved by any other users.
- Only the user who posted the item can delete it.
- Some Hidden rules for users from different college (SaaS Angle):
  (1) Users from Chung Chi College will see items from Chung Chi College and S.H.HO College listed with priority
  (2) Users from United College will see items from United College and New Asia College listed with priority
  (3) Only users from Shaw College can reserve items from their college
  The priority effect will disappear after filter sorting is set.
