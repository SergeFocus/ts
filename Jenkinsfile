def File1CDD 
def versionText
def versionValue

def scannerHome
def configurationText
def configurationVersion

pipeline{
    
    agent{
        label 'bdd'
        }
    
  //  environment{
  //      Storage = credentials('Storage_Trad_CiBot')
  //  }
    
 //   triggers {
   //     cron("H/5 * * * *")
     //   }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        
        stage ('Hello World') {
            steps {
                timestamps {
                    echo 'Привет Мир!'    
                }   
            }
        }     
        
    stage ('Статический анализ') {
            steps {
                timestamps {
                   script{
                    if(env.BUILD_NUMBER.endsWith("0")) {
                     build job: 'cyclo', wait: false  
                     build job: 'cpd', wait: false                 
                        }
                     scannerHome = tool 'Sonar-Scanner' 
                     configurationText  =  readFile encoding: 'UTF-8', file: 'src/cf/Configuration.xml'
                     configurationVersion =  (configurationText =~ /<Version>(.*)<\/Version>/)[0][1]  
                    }
                    withSonarQubeEnv('SonarQube'){
                    echo 'SonarQube'
                    //cmd("chcp 65001\n sonar-scanner -Dsonar.host.url=https://sonar.silverbulleters.org -Dsonar.login=a50ca9b3a3bfd77a6d3cf184c3f9fbfd8e01c9ef -Dsonar.projectVersion=1.0.0.0")
                    cmd("chcp 65001\n ${scannerHome}/bin/sonar-scanner -Dsonar.projectVersion=${configurationVersion}")

                    }
                }   
            }
        }

         

        }
    }        

def cmd(command) {
    if(isUnix()){
        sh "${command}"
    } else {
        bat "chcp 65001\n${command}"
    }
}
