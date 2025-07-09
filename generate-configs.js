// generate-configs.js
const fs = require('fs');

function generateConfig(templatePath, outputPath, vars) {
  let content = fs.readFileSync(templatePath, 'utf8');
  Object.entries(vars).forEach(([key, val]) => {
    content = content.replace(new RegExp(`\\$\\{${key}\\}`, 'g'), val);
  });
  fs.writeFileSync(outputPath, content);
  console.log(`✅ ${outputPath} written`);
}

const vars = {
  ACCESS_TOKEN: process.env.ACCESS_TOKEN || '',
  APIM_SERVICE_NAME: process.env.APIM_SERVICE_NAME || '',
  GOOGLE_FONTS_API_KEY: process.env.GOOGLE_FONTS_API_KEY || '',
};

generateConfig('config.design.template.json', 'src/config.design.json', vars);
generateConfig('config.publish.template.json', 'src/config.publish.json', vars);
generateConfig('config.runtime.template.json', 'src/config.runtime.json', vars);