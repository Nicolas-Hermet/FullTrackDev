import TagCloud from 'TagCloud'

const container = '.tagcloud';
const texts = [
    'Backend Developer', 'Frontend Developer', 'Racing Driver', 'Remote Advisor', 'Engineer'
];
const options = {
  radius: 400, 
  maxSpeed: 'slow',
  initSpeed: 'slow',

};

TagCloud(container, texts, options);