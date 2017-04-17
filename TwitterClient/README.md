
# CodePath Course Week 3 Project: Twitter Client

**Twitter Client** is a basic twitter app to read and compose tweets the [Twitter API](http://api.twitter.com).

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] Custom cells should have the proper Auto Layout constraints.
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit - instead of upper right I have in below the textview
- [y] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network
- [x] Optional: Retweeting and favoriting should increment the retweet and favorite count.
- [x] Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. Refer to this guide for help on implementing unretweeting - in tweet details page it's done but in reply page yet to be done'
- [x] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to open a reply segway once clicked in table view cell 
2. How to pass the information back from model push segue back to original controller 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/uttamsingh/twitter-client/blob/master/TwitterClient/Twitter.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## License

Copyright [2017] [Uttam SIngh]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
