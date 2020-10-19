const http = require('http');
const port = process.env.PORT || 3000;

const echo = contentType => (res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', contentType);
    res.end(res.body || 'EMPTY')
};

const sendText = echo('text/plain');

http.createServer(
    (req, res) => sendText(res)
).listen(Number(port))