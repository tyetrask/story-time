###* @jsx React.DOM ###

StoryTime.React.Browse = React.createClass
  
  app: ->
    window.StoryTime
  
  render: ->
      `<div id='stories-container' class='col-xs-4 col-xs-offset-1'>
         <div class='panel panel-default'>
           <div class='panel-heading text-center'>
             <strong>My Work</strong>
           </div>
           
           <div id='my-work-story-list' class="list-group">
           </div>
         </div>
   
         <div class='panel panel-default'>
           <div class='panel-heading text-center'>
             <strong>Upcoming</strong>
           </div>
           <div id='upcoming-story-list' class='list-group'>
        
           </div>
         </div>
       </div>
  
       <div id='clock-container' class='col-xs-6'>
         <div class='panel panel-primary'>
           <div class='panel-heading text-center'>
             Clock
           </div>
           <div class='list-group'>
           </div>
         </div>
       </div>`
