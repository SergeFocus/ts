def File1CDD 
def versionText
def versionValue

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
        
        stage ('Загрузка с хранилища и обновление базы') {
            steps {
                timestamps {
                    script {
                   File1CDD = "F:/mitest/workspace/1c_trade_bdd" 
                   versionText  =  readFile encoding: 'UTF-8', file: 'src/cf/VERSION'
                   versiversionValue =  (versionText =~ /<VERSION>(.*)<\/VERSION>/)[0][1]
                   }
                     cmd("chcp 65001\n deployka loadrepo   \"/FF:/mitest/workspace/1c_trade_bdd\" \"F:/mitest/workspace/storage_trade\" -storage-user ci-bot -storage-pwd password -storage-v ${versiversionValue}  -storage-ver ${versionValue} -v8version 8.3.10")
                //   cmd("chcp 65001\n deployka loadrepo \"/F${File1CDD}\" \"F:/mitest/workspace/storage_trade\" -storage-user ${env.StorageUser} -storage-pwd ${env.StoragePwd} -v8version 8.3.10 -v8version 8.3.10 -storage-ver ${versionValue} ")
                   cmd("deployka dbupdate \"/F${File1CDD}\" -allow-warnings -v8version 8.3.10\"")
                   }   
                }  
           }

           stage ('Дымовое тестирование') {
               steps {
                   timestamps {
                       cmd("vrunner xunit ./tools/xUnitFor1C/Tests/Smoke --pathxunit ./tools/xUnitFor1C/xddTestRunner.epf --reportsxunit \"ГенераторОтчетаJUnitXML{out/junit.xml}\" --xddExitCodePath ./out/junitstdtus.log --v8version 8.3.10 --ibname  \"/F${File1CDD}\"")
          //                      echo 'Привет Мир!' 
                   }
               }
           }

         stage ('TDD test') {
               steps {
                   timestamps {
                       cmd("vrunner xunit ./Tests --pathxunit ./tools/xUnitFor1C/xddTestRunner.epf --reportsxunit \"ГенераторОтчетаJUnitXML{out/junit.xml}\" --xddExitCodePath ./out/junitstdtus.log --v8version 8.3.10 --ibname  \"/F${File1CDD}\"")
          
                   }
               }
           }

        stage('Проверка поведения') {
            steps {
                timestamps {
            cmd("vrunner vanessa --pathvanessa ./tools/vanessa-behavior/vanessa-behavior.epf --vanessasettings ./tools/VBParams.json  --workspace . --v8version 8.3.10 --ibname  \"/F${File1CDD}\"")
                }   
            }
        }

          stage('Публикация результата') {
            steps {
                    script {
                        def allurePath = tool name: 'allure', type: 'allure'
                        cmd("${allurePath}/bin/allure generate -o out/publishHTML/allure-report out/allure")
                    }
                        junit allowEmptyResults: true, testResults: 'out/junit.xml'
                        cmd("pickles -f features -o out/publishHTML/pickles -l ru --df dhtml --sn \"Trade\"")

                    publishHTML target: [
                        allowMissing: false, 
                        alwaysLinkToLastBuild: false, 
                        keepAll: false, 
                        reportDir: 'out/publishHTML', 
                        reportFiles: 'allure-report/index.html,pickles/Index.html', 
                        reportName: 'HTML Report'
                    ]
                    step([
                        $class: 'CucumberReportPublisher',
                        fileIncludePattern:'*.json',
                        jsonReportDirectory: 'out/Cucumber'
                    ])
                }   
            }
       stage('Подготовка Дистрибутива') {
            steps {
                timestamps {
              cmd("packman load-storage F:/mitest/workspace/storage_trade -use-tool1cd -storage-v ${versiversionValue}")
              cmd("packman  make-cf")
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
