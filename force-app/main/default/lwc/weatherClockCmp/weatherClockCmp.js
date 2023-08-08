/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, track } from 'lwc';

const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const options = { year: 'numeric', month: 'long', day: 'numeric' };
const token = '64ae9f784f957b775fcb1082923487be';


export default class weatherClockCmp extends LightningElement {

    @track todayDate;
    @track temprature;
    @track cityName;
    @track weatherImg;
    response;

    connectedCallback() {

        this.todayDate = new Date().toLocaleString('en-US', options);
        navigator.geolocation.getCurrentPosition(this.getWeatherData, this.error);
        setInterval(() => requestAnimationFrame(updateTime), 1000);

        function updateTime() {
            let today = new Date();
            document.documentElement.style.setProperty('--timer-day', "'" + days[today.getDay()] + "'");
            document.documentElement.style.setProperty('--timer-hours', "'" + today.getHours() + "'");
            document.documentElement.style.setProperty('--timer-minutes', "'" + today.getMinutes() + "'");
            document.documentElement.style.setProperty('--timer-seconds', "'" + today.getSeconds() + "'");
            requestAnimationFrame(updateTime);
        }
    }

    getWeatherData = async (pos) => {
        let crd = pos.coords;
        let url = `https://api.openweathermap.org/data/2.5/weather?units=metric&lat=${crd.latitude}&lon=${crd.longitude}&appid=${token}`;
        let data = await fetch(url);
        this.response = await data.json();
        this.temprature = Math.round(this.response.main.temp);
        this.cityName = this.response.name;
        this.weatherImg = `https://openweathermap.org/img/w/${this.response.weather[0].icon}.png`;
    }
}