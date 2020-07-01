import http from 'http';
import helloWorldService from './services/hello-world';
import weatherService from './services/weather';

const routes: {[pathPattern: string]: http.RequestListener} = {
    '/': helloWorldService,
    '/weather': weatherService
}

function routeHandler(url: URL, req: http.IncomingMessage, res: http.ServerResponse): void {
    for (const pathPattern in routes) {
        if (new RegExp(`^${pathPattern}$`).test(url.pathname)) {
            routes[pathPattern](req, res);
            return;
        }
    }
    res.writeHead(404);
    res.end('404 - Not Found');
}

export default routeHandler;