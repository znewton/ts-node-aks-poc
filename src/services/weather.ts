import http from 'http';
import https from 'https';

async function weatherService(req: http.IncomingMessage, res: http.ServerResponse): Promise<void> {
    const weather = await new Promise<string>((resolve) => {
        let weatherResult = '';
        const weatherRequest = https.request('https://wttr.in/Seattle?format=j1', {method: 'GET'}, (result) => {
            result.on('data', (d) => {
                weatherResult += d;
            });
            result.on('end', () => {
                resolve(weatherResult);
            })
        });
        weatherRequest.on('error', (e) => {
            console.error(e);
            res.writeHead(500);
            res.end('Failed to retrieve weather data');
        });
        weatherRequest.end()
    });
    if (!res.finished) {
        const parsedWeather = JSON.parse(weather);
        const simplifiedWeather = {
            current_condition: parsedWeather.current_condition
        }
        res.setHeader('Content-Type', 'application/json')
        res.writeHead(200);
        res.end(JSON.stringify(simplifiedWeather));
    }
}

export default weatherService;