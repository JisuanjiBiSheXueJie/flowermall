    $(function(){
              
              
              $(".ui-select-trigger").click(function(){
              
                  var  trigger=$(this);
                  trigger.css("display","block");
                  var point= trigger.position();
                  var triggercontent=$("#"+trigger.attr("trigger-content"));
                  
                  triggercontent.css("left",point.left);
                  triggercontent.css("top",point.top+$(this).height());
                  triggercontent.show();
                 
              })
              
              $(".ui-select-trigger").each(function(){
                
                   if($(this).attr("textfieldId")!=null)
                   {
                       $(this).text( $("#"+$(this).attr("textfieldId")).val());
                   }
                   
              });
              //DropDownItem Click
              $(".ui-select>ul>li").click(function(){
              
                   
                   if($(this).closest(".ui-select").is(":visible"))
                   {
                     
                      $(this).closest(".ui-select").hide();
                      
                      
                      
                      var  trigerid= $(this).closest("ul").attr("menu-trigger");
                     
                      var  triger=$("#"+trigerid);
                      triger.text($(this).text());
                    
                     if(triger.attr("valuefieldId")!=null)
                      {
                        
                         $("#"+triger.attr("valuefieldId")).val($(this).attr("value"));
                        
                      }
                      if(triger.attr("textfieldId")!=null)
                      {
                        
                         $("#"+triger.attr("textfieldId")).val($(this).text());
                      }
                     
                     
                      
                   }
                   
              }).hover(function(){
                    
                         $(this).addClass("ui-select-item-selected");
                    },function(){
                    
                         $(this).removeClass("ui-select-item-selected");
              });
              
              
                /*open-window-button*/
              $(".ui-open-trigger").click(function(){
           
                var bindtextid="#"+ $(this).attr("textfieldid");
                var bindvalueid="#"+ $(this).attr("valuefieldid");
                var windowurl=$(this).attr("url");
                var windowtitle=$(this).attr("window_title")
                
                var windowwidth=parseInt($(this).attr("window_width"),10);
                
                var windowheight=parseInt($(this).attr("window_height"),10);
               
              
               
                if(windowheight==null)
                  windowheight=600;
                if(windowwidth==null)
                   windowwidth=800;
                
                var open_button=$(this);
                
                $.dialog.open(windowurl,{
                     title:windowtitle,
                     width:windowwidth,
                     height:windowheight,
                     lock:true,
                     ok: function () {
    	                
    	                
    	              var activeWindow = this.iframe.contentWindow;
    	                if (!activeWindow.document.body) {
        	                alert('?????????????????????')
        	                return false;
                        };
                     if(activeWindow.$(":radio[name=radChoose]:checked").size()<=0)
                     {
                           $.dialog.alert("???????????????");
                           return false;
                     }
                     var  bindvalue=activeWindow.$(":radio[name=radChoose]:checked").attr("bindvalue");
                     var  bindtext=activeWindow.$(":radio[name=radChoose]:checked").attr("bindtext");
    	             open_button.text(bindtext+"("+bindvalue+")");
    	             $(bindtextid).val(bindtext);
    	             $(bindvalueid).val(bindvalue);
    	               
    	             this.close();
    	                
       	             return false;
                    },
                    cancel: true
                });
          
          })//end click
          
          
          
           $(".ui-open-trigger").each(function(){
                
                   if($(this).attr("textfieldId")!=null)
                   {
                       $(this).text( $("#"+$(this).attr("textfieldId")).val());
                   }
                   if($(this).attr("valuefieldId")!=null)
                   {
                     if($("#"+$(this).attr("valuefieldId")).val()!="")
                      $(this).text($(this).text()+"("+ $("#"+$(this).attr("valuefieldId")).val()+")");
                     else
                      $(this).text("????????????");
                   }
                   
          });
         
            
          
         
  })
  
  
function  runCallback(objid)
{
   if ($(".checkall input:checked").size() < 1) {
   
         $.dialog({
            title: '????????????',
            content: '????????????????????????????????????????????????',
            icon: 'warn',
           
            ok: function(){
              
                this.close();
            }
            
        });
       
        return false;
    }
    
    
         $.dialog({
            title: '????????????',
            content: '?????????????????????????????????????????????',
            icon: 'warn',
           
            ok: function(){
                __doPostBack(objid, '');
               this.title('????????????').content('??????????????????').lock().time(2);
               return false;
            },
            cancel:function(){
               this.close();
               return false;
            }
            
        });
        return false;
  
}



(function($){
	  
	  $.fn.recordTable = function(options){
		var defaults = {
			evenRowClass:"evenRow",
			oddRowClass:"oddRow",
			activeRowClass:"activeRow"			
		}
		var options = $.extend(defaults, options);
		this.each(function(){
			var thisTable=$(this);
			
			//?????????????????????
			$(thisTable).find("tr:even").addClass(options.evenRowClass);
			$(thisTable).find("tr:odd").addClass(options.oddRowClass);
			//?????????????????????
			$(thisTable).find("tr").bind("mouseover",function(){
				$(this).addClass(options.activeRowClass);
			});
			$(thisTable).find("tr").bind("mouseout",function(){
				$(this).removeClass(options.activeRowClass);
			});
		});
	};
	
	
	$.fn.daowenTip = function(divId) {  
        var div = $("#" + divId); //????????????????????????????????????  
        div.css("position", "absolute");//??????????????????????????????
        //??????
        
        var self = $(this); //???????????? 
       
        div.mouseout(function(){
               
            div.hide();
              
        });
        self.hover(function() {  
           
            targetPosition=$(this).offset(); 
            
            div.css("display", "block");  
            
            div.css("left", targetPosition.left);  
           
            div.css("top", targetPosition.top+2);  
       
            div.show();
            
          
           
        });  
        return this;  
  }
	
	
	
})(jQuery);






