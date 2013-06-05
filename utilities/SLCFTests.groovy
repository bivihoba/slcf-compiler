class SLCFTests extends GroovyTestCase{
	def failedAssertions = []

	void testSLCF(){
		def currentDirectory = new File(getClass().protectionDomain.codeSource.location.path).parent
		def xslTemplateUri = currentDirectory + '/master.xsl'

		def testXmlUri = currentDirectory + '/../pages/tests.xml'
		def proc = "xsltproc --xinclude ${testXmlUri} ${xslTemplateUri}".execute()
		proc.waitFor()
		def xml = proc.in.text
		def parser = new XmlParser() 
		parser.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false); 
		parser.setFeature("http://xml.org/sax/features/namespaces", false) 
		def testXml = parser.parseText(xml) 

		testXml.depthFirst().findAll{it.name() =~ 'test'}.each{
			def sourceList = it.source.inject([]){acc, next -> acc + next.children()};
			def htmlList = it.html.inject([]){acc, next -> acc + next.children()};
			def doc = it.doc.text()
			def sourceString = sourceList.toString().replace('  ', ' ')
			def htmlString = htmlList.toString()
			try{ 
				assert sourceString == htmlString: doc
			} catch(AssertionError e){
				failedAssertions << e	
			}
		}
        	if (failedAssertions) {
	            throw new Exception("${failedAssertions.size()} failed assertions found:\n${failedAssertions.message.join('\n')}")
	        }
	}
}
