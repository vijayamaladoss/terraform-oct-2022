# Day 5 - Terraform CI/CD Pipeline in Azure

## What is DevOps?
- is combination of process and tools 
- to confidently release frequent releases to end customer without any defects
- to speed up faster time to market
- Developers
  - automates the Unit/Integrating testing using Unit Test Frameworks
  - using Junit/TestNg, Mockito - Java
  - Using NUnit/Moq - C#
  - Using GoogleTest/GoogleMock - C/C++
- QA
  - automates the end-2-end functional test, component test, API test, smoke test, regression test, performance, stress and load test,etc
  - using Selenium, BDD Frameworks like Cucumber, Specflow, Jasmine, Karma, etc.,
- Operations Team ( System Administrators, DevOps Engineers )
  - automate Infrastructure provisioning ( Docker, Terraform, etc .,)
  - automate software installation using Ansible

## What is Continuous Integration?
- logically completed code should be integrated several times a day
- developers should add Unit & Integration Test cases as part of the code they are integrating
- each time code is committed into source control repository, Jenkins or similar CI/CD servers will take latest code and build and test and share the build report
- if the code committed let to build failures, it means some test cases failed, which is good. In other words, your automated test cases found a bug

## What is Continuous Deployment?
- each time code is pushed/integrated in Source Control repository, the code is build and tested
- the tested application binaries can be deployed automatically to QA environment for further manual/automated testing

## What is Continuous Delivery?
- the QA tested binaries will be automatically delived to customer's environment
- the customer can review the binary if everything is working as per the requirement
- in certain cases, the binaries will deployed onto live prod environment if the organization's DevOps process is so matured that they are confident to make the product live based the build/test report

## What are Azure DevOps Tools?
- For your organization you can create an Organization within Azure Cloud
- The Digital Origanization created within Azure Cloud supports the below
  - Board


## Use this repository for Azure pipeline
<pre>
https://github.com/tektutor/hello-spring-boot.git
</pre>

## What is an Azure Pipeline?
<pre>
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- main

pool:
  vmImage: ubuntu-latest

steps:
- script: mvn clean compile
  displayName: 'Build the Spring Boot Microservice application code'

- script: mvn test
  displayName: 'Unit Test application binaries'

- script: mvn package
  displayName: 'Unit Test application binaries'

</pre>
