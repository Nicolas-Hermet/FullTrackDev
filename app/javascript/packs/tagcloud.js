import TagCloud from 'TagCloud'

const container = '.tagcloud';
const texts = [
    'a Backend Developer', 'a Frontend Developer', 'a Racing Driver', 'a Remote Advisor', 'an Engineer'
];
const options = {
  radius: 400, 
  maxSpeed: 'slow',
  initSpeed: 'slow',

};

TagCloud(container, texts, options);