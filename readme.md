# eslisp-chain

<!-- !test program
sed 's/(require "eslisp-chain")/(require ".\\/index")/' \
| ./node_modules/.bin/eslc \
| head -c -1
-->

An [eslisp][] macro for chaining method calls on a single object.

## Examples

The macro is best suited for APIs whose methods return the same 
object to make it possible to chain sebsequent method calls.  _eslisp_'s 
functional syntax makes such API rather tedious to use. 

Consider the following example in JavaScript:

<!-- !test out chain methods -->

    service.method('greet', function (name) {
        return 'Hello, ' + (name + '!');
    }).listen();

This can be expressed in _eslisp_ with the following code:

    ((. 
      ((. service method) "greet" (lambda (name)
        (return (+ "Hello, " name "!"))))
      listen))

As the number of method calls increases, this inside-out functional syntax can 
get unwieldy, with multiple nested `((.` invocations.

The _eslisp-chain_ macro makes it possible to write the same code in 
a sequential manner:

<!-- !test in chain methods -->

    (macro -> (require "eslisp-chain"))
    (-> service
      (method "greet" (lambda (name)
        (return (+ "Hello, " name "!"))))
      (listen))


This syntax is convenient for chaining promises:

<!-- !test in chain promises -->

    (macro -> (require "eslisp-chain"))
    (-> (read "data.json")
      (then (. JSON parse))
      (then (lambda (obj)
        (return ((. Object keys) obj))))
      (catch (. console error)))

↓

<!-- !test out chain promises -->

    read('data.json').then(JSON.parse).then(function (obj) {
        return Object.keys(obj);
    }).catch(console.error);


It can be used to compose array methods:

<!-- !test in chain array methods -->

    (macro -> (require "eslisp-chain"))
    (-> Object
      (keys data)
      (filter (lambda (key)
        (return (!== (get key 0) "_"))))
      (forEach processPublicMembers))

↓

<!-- !test out chain array methods -->

    Object.keys(data).filter(function (key) {
        return key[0] !== '_';
    }).forEach(processPublicMembers);


The macro offers an alternative even for single method calls where there is no 
chaining:

<!-- !test in single method accessor -->

    (macro -> (require "eslisp-chain"))
    (-> app
      (get "/" (lambda (req, res)
        ((. res send) "Hello, world!"))))

    (-> app
      (listen 3000))

↓

<!-- !test out single method accessor -->

    app.get('/', function (req, unquote(res)) {
        res.send('Hello, world!');
    });
    app.listen(3000);

[eslisp]: https://www.npmjs.com/package/eslisp
