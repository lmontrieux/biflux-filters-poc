sourceDtd = source.dtd
tartgetDtd = view.dtd
update = transformations/transformation.upd
sourceXML = source.xml 
targetXML = view.xml 

all: u

u: u.hs
	ghc u.hs

u.hs: $(sourceDtd) $(tartgetDtd) $(update)
	./biflux --sdtd=$(sourceDtd) --vdtd=$(tartgetDtd) --bx=$(update)  --bxhs=u.hs

forward: u $(sourceXML) $(targetXML)
	cp $(targetXML) target.xml.backup
	./u -f -s $(sourceXML) -t $(targetXML) -o $(targetXML)
	cp $(targetXML) targetXML.temp
	xmllint --format targetXML.temp > $(targetXML)
	rm targetXML.temp

backward: u $(sourceXML) $(targetXML)
	cp $(sourceXML) source.xml.backup
	./u -b -s $(sourceXML) -t $(targetXML) -o $(sourceXML)	
	cp $(sourceXML) sourceXML.temp
	xmllint --format sourceXML.temp > $(sourceXML)
	rm sourceXML.temp


recs:
	mv source.xml.backup $(sourceXML)

recv:
	mv target.xml.backup $(targetXML)

rec:
	mv source.xml.backup $(sourceXML)
	mv target.xml.backup $(targetXML)

shows:
	cat $(sourceXML)

showt:
	cat $(targetXML)	

clean:
	rm -r *.hs *.hi *.o  u
