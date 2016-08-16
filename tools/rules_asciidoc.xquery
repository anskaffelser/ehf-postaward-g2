declare namespace xsd = "http://www.w3.org/2001/XMLSchema";
declare namespace saxon = "http://saxon.sf.net/";
declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";
declare namespace schold = "http://www.ascc.net/xml/schematron";
declare namespace iso = "http://purl.oclc.org/dsdl/schematron";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace cbc = "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2";
declare namespace cac = "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2";
declare namespace ubl = "urn:oasis:names:specification:ubl:schema:xsd:CallForTenders-2";
declare namespace svrl = "http://purl.oclc.org/dsdl/svrl";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";


for
$x in //iso:pattern/iso:rule/iso:assert

let $RuleId := string($x/@id)
let $rule := string($x/../@context)
let $flag := string($x/@flag)
let $assert := string($x/@test)
let $tekst := $x/text()

return

    concat(".3+| ", $RuleId, " *(", $flag , ")* | *", $tekst, "* | ",  $rule, " | ", $assert, "&#10;")
