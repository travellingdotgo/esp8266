wifi.sta.disconnect()
tmr.delay(100)
wifi.setmode(wifi.STATION)  
wifi.sta.config("wifiap-name","hahahaha")     --����·���������Ҫ�����Լ���·�����趨�����޸�
wifi.sta.connect() 
i=0
tmr.alarm(0,8000, 1, function() 
	if wifi.sta.getip()== nil then 
		print("IP unavaiable, Waiting...")
		i=i+1
		if(i>10) then                      --���20�뻹û������wifi����������Ƭ��
			print("restart nodeMCU")
			node.restart()
		end
		wifi.sta.disconnect()              --���2��û������wifi����������һ��
		wifi.sta.connect()
	else 
		tmr.stop(0)
		print("Config done, IP is "..wifi.sta.getip())
	end 
end)
 
led1 = 3  
led2 = 4  
gpio.mode(led1, gpio.OUTPUT)  
gpio.mode(led2, gpio.OUTPUT)  
srv=net.createServer(net.TCP)  
srv:listen(80,function(conn)  
    conn:on("receive", function(client,request)  
        local buf = "";  
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");  
        if(method == nil)then  
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");  
        end  
        local _GET = {}  
        if (vars ~= nil)then  
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do  
                _GET[k] = v  
            end  
        end  
        
        --����һ����ҳ���ͻ���
	--��ҳ�Ŀ�ͷ��������ҳ���ȣ�������������յ�ʲôʱ���ֹ��Ҫ��\r\n�ָ�        
	--buf = buf.."HTTP/1.1 200 OK\r\n"
	--buf = buf.."Content-Type: text/html\r\n"
	--buf = buf.."Content-Length:60\r\n"   --���ö�����ʽ������ҳ
	--buf = buf.."\r\n"
		
	--��ҳ������
	buf = buf.."<!DOCTYPE html>"
	buf = buf.."<html>"
	buf = buf.."<title>My wifi Switch</title>" 
	buf = buf.."<body>" 
	buf = buf.."<p style='font-size: X-large'>GPIO0 <a href=\"?pin=ON1\"><button style='font-size: X-large'>ON</button></a> <a href=\"?pin=OFF1\"><button style='font-size: X-large'>OFF</button></a></p>";  
	buf = buf.."<p style='font-size: X-large'>GPIO2 <a href=\"?pin=ON2\"><button style='font-size: X-large'>ON</button></a> <a href=\"?pin=OFF2\"><button style='font-size: X-large'>OFF</button></a></p>";  
	buf = buf.."</body>"
	buf = buf.."</html>\r\n"
	buf = buf.."\r\n"
	
	 
        local _on,_off = "",""  

      if (vars ~= nil)then
        if(_GET.pin == "ON1")then  
              gpio.write(led1, gpio.HIGH);  
        elseif(_GET.pin == "OFF1")then  
              gpio.write(led1, gpio.LOW);  
        elseif(_GET.pin == "ON2")then  
              gpio.write(led2, gpio.HIGH);  
        elseif(_GET.pin == "OFF2")then  
              gpio.write(led2, gpio.LOW);  
        end  
     end
        client:send(buf);  
        client:close();  
        collectgarbage();  
    end)  
end)  
