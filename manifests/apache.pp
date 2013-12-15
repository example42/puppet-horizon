class horizon::apache {
  include apache
  apache::module { 'wsgi': }
}
