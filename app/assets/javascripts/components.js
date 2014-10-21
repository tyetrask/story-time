// This is a React manifest file that'll be compiled into components.js, which will include all the files
// listed below.
//
//= require_self
//= require_tree ./components

if (typeof StoryTime === 'undefined' || StoryTime === null) {
  window.StoryTime = { React: {} };
}
