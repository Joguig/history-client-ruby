pipeline {
  agent none
  options {
    timestamps()
    ansiColor('xterm')
  }

  environment {
    CODECOV_SLUG="admin-services/history-client-ruby"
    CODECOV_URL="https://codecov.internal.justin.tv"
    CI="true"
    REPO="https://packages.internal.justin.tv/artifactory/api/gems/v-rubygems"
  }

  stages {
    stage('build') {
      agent {
        docker {
          image 'ruby:2.5.1'
          args '-u root'
        }
      }
      steps {
        sh 'bundle install'
        sh 'bundle exec rubocop'
        withCredentials([
          [$class: 'StringBinding', credentialsId: 'history-client-ruby-codecov-token', variable: 'CODECOV_TOKEN']
        ]) {
          sh 'bundle exec rspec'
        }
        sh 'mkdir -p build'
        sh 'gem build history-client.gemspec'
        sh 'mv *.gem build'
        stash name: 'build', includes: 'build/*.gem'
        sh 'chown -R 61000:61000 build'
        sh 'chown -R 61000:61000 coverage'
      }
    }

    stage('deploy') {
      agent {
        docker {
          image 'ruby:2.5.1'
          args '-u root'
        }
      }
      when { branch 'master' }
      steps {
        unstash name: 'build'
        sh 'mkdir -p ~/.gem'
        withCredentials([
          [$class: 'StringBinding', credentialsId: 'dta_tools_deploy', variable: 'DTA_TOOLS_DEPLOY_PASS']
        ]) {
          sh 'curl -udta_tools:$DTA_TOOLS_DEPLOY_PASS $REPO/api/v1/api_key.yaml > ~/.gem/credentials'
        }
        sh 'chmod 600 ~/.gem/credentials'
        sh 'gem push build/*.gem --host $REPO'
      }
    }
  }
}
