// 在客户端和服务器端都会加载
// CoffeeScript定义全局变量不方便，所以使用Javascript

Pots = new Meteor.Collection('pots');
Leaves = new Meteor.Collection('leaves');
Tags = new Meteor.Collection('tags');
Comments = new Meteor.Collection('comments');
