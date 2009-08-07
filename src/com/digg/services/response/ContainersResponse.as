package com.digg.services.response
{
    import com.digg.model.Container;
    
    import flash.xml.XMLNode;

    public class ContainersResponse extends Response
    {
        override protected function loadItems(node:XMLNode):uint
        {
            items = new Array();
            
            if (node.hasChildNodes())
            {
                for (var child:XMLNode = node.firstChild; child; child = child.nextSibling)
                {
                    var container:Container = Container.fromXML(child, model);
                    items.push(container);
                }
            }
            
            return items.length;
        }
    }
}