extends Control

@export var richTextLabel : RichTextLabel
var textItemsInFile : Array

class TextFile:
	var itemName : String = ""
	var subject : String = ""
	var text : String = ""

func _ready() -> void:
	readFile("res://Data/written_words.xml")

func readFile(file : String):
	# search through the xml file for the correct name
	var parser = XMLParser.new()
	parser.open(file)
	var node_name : String
	var item : TextFile 
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			node_name = parser.get_node_name()
			if(node_name == "item"):
				item = TextFile.new()
		elif(parser.get_node_type() == XMLParser.NODE_TEXT):
			if(node_name == ""):
				pass
			elif(node_name == "name"):
				item.itemName = parser.get_node_data()
			elif(node_name == "subject"):
				item.subject = parser.get_node_data()
			elif(node_name == "text"):
				item.text = parser.get_node_data()
		elif(parser.get_node_type() == XMLParser.NODE_ELEMENT_END):
			node_name = ""
			if(parser.get_node_name() == "item"):
				textItemsInFile.append(item)

func changeText(m_name : String):
	var newText : String
	for i in range(textItemsInFile.size()):
		if(m_name == textItemsInFile[i].itemName):
			newText = m_name + ":\n\n" + textItemsInFile[i].subject + '\n\n' + textItemsInFile[i].text
	richTextLabel.text = newText
