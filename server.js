console.log("Node + TS ready on port 3000"); import("http").then(http => http.createServer((req,res)=>{res.end("OK")}).listen(3000);
