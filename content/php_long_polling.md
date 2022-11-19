Title: PHP - Long Polling
Date: 2012-07-18 11:25
Category: PHP
Tags: PHP

Long Polling is a technique used when you need create a real time application,
where the server will wait from a event occur to response the request.

On this example, we will create a webchat, using a simple text file.
The server will read the text file,
and will hold the conection until the file has new lines.
To check it, the server will receive the current line number.

Go to the code


```PHP
<?php
// Disable max runtime
set_time_limit(0);
function poll($cur_line){    
    // An infinite loop
    while(true){    
        // Read the file
        $data = file_get_contents('chat.txt');
        $lines = explode("\n", $data);

        if(count($lines) == $cur_line || empty($lines[0])){
            // Sleep for 1 seccond if no new line
            sleep(1); 
        }else{
            $ret = array();
            $ret['lines'] = array();
            // Put new lines in the vector
            for($cur_line; $cur_line < count($lines); $cur_line++){
                $ret['lines'][] = $lines[$cur_line];
            }
            // Update the cur_line to response
            $ret['cur_line'] = $cur_line;
            // Return an JSON
            return json_encode($ret);
        }
    }
}

// echo the result
echo poll($_POST['cur_line']);
?>
```

You can see the complete code [here](https://github.com/carlosmaniero/Php-long-polling)

---
#### Old Post
This is an old post migrated from my old blog. 
You can see the original content [here](http://carlosmaniero.blogspot.com.br/2012/07/php-long-polling.html)[pt-br]
