## Description
- I build a service that manages and manipulates trees.
- with the piece of codeI'll be ready to demonstrate
- Good design decisions.
- Ability to consider edge cases.
- Documentation

## Development Environment
- make sure you have the right version install in your system.
- ruby 3.0.0p0
- Rails 6.1.7.6
- If you do not have same version available in your system, then download the correct version from here. [Link](https://gorails.com/setup/macos/13-ventura)
- Or You can use the following command to install the required version.
```aidl
rbenv install -l
rbenv install 3.0.0
rbenv local 3.0.0
ruby -v     #by this time it should display ruby 3.0.0p0
echo "gem: --no-document" > ~/.gemrc
gem install bundler
gem env home
gem install rails -v 6.1.7.4
rbenv rehash
rails -v #by this time it should display Rails 6.1.7.6
```

## How to run this project

```
git clone git@github.com:Indrajitnaiya09/hinge_health_interactive_tree.git
```
- open new terminal and navigate to the correct directory
1.  Recommended way: Run using Docker (Docker should be installed in your system.)
```aidl
docker-compose up
```
2. Running on local system(Optional)
- ENV variable need to set in:
  * DB_NAME
  * DB_USERNAME
  * DB_PASSWORD

```
bundle install
rails db:create
rails db:migrate
rails s -p 3000 

```

Using postman do GET / POST http://localhost:3000/api/tree

```
body:
{
    "parent": null,
    "label": "Root"
}
```
will be able to validate
Task 1:
- The data structure that represents [the animals example](https://github.com/Hinge-Health-Recruiting/interviews-services_indrajitnaiya09).
- Will cause a node to be added to the end of a list of children, a new unique id should be assigned by the service.
- The response should be simple
  Task 2:
- Implement the route, and ensure that a GET /interactive_nodes request returns the updated tree.

## Implementation summary:
- `POST` with body parameters
```aidl
{
    "parent": null,
    "label": "some_name"
}
```
consider as valid params, and insert as root node.
- If one node is present as root node, then it'll insert as 2nd position/index.
- default operation(search and insert) will perform only in a 0th index.
- Introduced `root_index` as an optional params. So, if user pass any `root_index` value, then will check that index is
  present or not. If present, then operation(search and insert) will perform on that index.

Example of CURL Calls can be found in `curl.txt`
