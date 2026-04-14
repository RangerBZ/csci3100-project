# Campus Trade

## Project Overview

Campus Trade is a secondhand trading website for the Chinese University of Hong Kong community.

## Team

| Name | Student ID | GitHub Username |
| --- | --- | --- |
| `HUANG Ruilin` | `1155211049` | `cuhk11049` |
| `LI Xiaodong` | `1155211265` | `derekli-114` |
| `[Member 3]` | `[1155xxxxxx]` | `[github-id]` |
| `[Member 4]` | `[1155xxxxxx]` | `[github-id]` |
| `[Member 5]` | `[1155xxxxxx]` | `[github-id]` |

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

| Feature | Description | Primary Contributor | Other Contributors|
| --- | --- | --- | --- |

| Basic CRUD Feautre | Main menu + Item display + Post item + Edit user profile + Naive purchase and reserve function | `LI Xiaodong` | `BING Zhe` |
| Account Register and Login | Register with name, email, location and password; Login with name and password | `LI Xiaodong` | `[Fill in]` |
| Login email restrictions | Register with validated `@link.cuhk.edu.hk` email | `HUANG Ruilin` | `[Fill in]` |
| Advanced Feature: Analytics | View charts and summaries for listing activity, categories, status, pricing, and community activity| `HUANG Ruilin` | `[Fill in]` |
| Advanced Feature: Search| Fuzzy search,Auto-complete | `HUANG Ruilin` | `[Fill in]` |
| Search and filtering | Search by keyword and filter by category, status, seller location, price range, and recent posting days | `[Fill in]` | `[Fill in]` |

## SimpleCov Report Screenshot

`TODO:` Replace the placeholder below with your actual SimpleCov report screenshot.

Example Markdown:

```md
![SimpleCov Report](docs/simplecov-report.png)
```

You can also add a short note below the screenshot:

`TODO:` Coverage summary: `[e.g. 92.4% line coverage on April 14, 2026]`

## Demo / Deployment

`TODO:` Add your deployed URL, demo video link, or leave this section out if not required.

- Demo URL: `[Fill in]`
- Demo video: `[Fill in]`

