# pushpop-product-hunt

Product Hunt plugin for [Pushpop](https://github.com/pushpop-project/pushpop).

- [Installation](#installation)
- [Usage](#usage)
  - [Post Functions](#[post]-functions)
  - [User Functions](#user-functions)
  - [Collection Functions](#collection-functions)
- [Todo](#todo)
- [Contributing](#contributing)

## Installation

Add `pushpop-product-hunt` to your Gemfile:

```ruby
gem 'pushpop-product-hunt'
```

or install it as a gem

```bash
$ gem install pushpop-product-hunt
```

## Usage

The product hunt plugin gives you an easy interface for pulling information out of Product Hunt. We've wrapped pretty much all of [Product Hunt's API](https://api.producthunt.com/v1/docs), so nearly everything is available to you.

Here's a quick preview of something a product hunt job could do

``` ruby
job 'alert me if Keen is on product hunt' do
	product_hunt do
		posts('https://keen.io')
	end

	step do |response|
		if response['posts'].length > 0
			response['posts']
		else
			false
		end
	end

	sendgrid do |posts|
		# Send the email
	end
end
```

In order to query the Product Hunt API, you will need to put an [application token](https://www.producthunt.com/v1/oauth/applications) in the `PRODUCT_HUNT_TOKEN` environment variable.

### Post Functions

**day([date])**

This requests all posts for a given day. By default, it will request posts from the current day.

Optionally, you can pass in a date specifier. Passing a number will get posts `N` days ago. Passing a string will attempt to parse that into a date, and request posts for that date.

``` ruby
product_hunt do
	day # Get today's posts
end

product_hunt do
	day 3 # Get posts from 3 days ago
end

product_hunt do
	day '2014-07-04' # Get posts from July 4th, 2014.
end
```

**posts([url])**

This will get the most recent page of posts.

You can optionally pass in a URL to this function to filter to only posts that match that URL.

``` ruby
product_hunt do
	posts # Get all posts
end

product_hunt do
	posts 'https://keen.io' # Get posts on keen.io
end
```

**post(id)**

Gets a single post with the given ID

``` ruby
product_hunt do
	post 1234 # Gets post 1234
end
```

### User Functions

**users()**

Gets all users

``` ruby
product_hunt do
	users # Get all users
end
```

**user(id)**

Gets a user with the specified ID.

``` ruby
product_hunt do
	user 4321 # Get user 4321
end
```

### Collection Functions

**collections()**

Get all collections

``` ruby
product_hunt do
	collections # Get all collections
end
```

**featured_collections()**

Gets all of the featured collections.

``` ruby
product_hunt do
	featured_collections # Get all featured collections
end
```

**collections(id)**

Gets the collection with the specified ID.

``` ruby
product_hunt do
	collection 6789 # Get collection 6789
end
```

## TODO

- Pagination
- Sorting
- Ordering

## Contributing

Code and documentation issues and pull requests are definitely welcome!