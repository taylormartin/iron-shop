
[![Build Status](https://travis-ci.org/TIY-iron-shop/iron-shop.png?branch=master)](https://travis-ci.org/TIY-iron-shop/iron-shop)
# Iron Shop

What is It?
---------------

This is a simple eCommerce store built by myself and two other classmates. Users can choose to be both a buyer and a seller, or just a seller. Essentially they have the option to specify whether or not they would like to list items for sale or not. The store uses Stripe for transaction processing and has an Angular search feature. There is also a price watch feature that allows users to have email alerts sent to them if an items price drops below a threshold which they specify.


Installation
----------------
First, clone the project:

```
git clone git@github.com:taylormartin/iron-shop.git
```

Navigate into the directory where it is installed, and bundle:

```
bundle install
```

Then set up the database:

Note: You will need Postgres installed on your computer to run this app.

```
rake db:setup
```

Running the Application:
----------------

```
rails s
```
