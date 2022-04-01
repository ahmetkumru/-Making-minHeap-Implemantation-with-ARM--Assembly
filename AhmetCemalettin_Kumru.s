	AREA minHeapProject,CODE,READWRITE
	
	ENTRY
	 
	
	LDR r0,=myArray         ;Array'imizin base adressini r0 registerine atiyoruz.
	MOV r6,#2  				;Gerekli yerlerde kullanilacak sabit.
	LDR r1,=0x40000000      ;heapimizin baslangic adresi.
	
	MOV r4,#1  				; parent node nin bulundudugu index.
	MOV r3,#1 				; heapimizin güncel node adedi -node eklendikçe bu deger 1 arttirilir 
	;ve daha sonra index degeri kullanilir-.
							

	
initMinHeap                 ;Min Heap olusturma
	LDR r2,[r0,r6,LSL#1]!   ;Diziden okunan deger 		
	CMP r2,#-1	            ;Son eleman kontrolü
	BEQ finishBuild	        ;r2= -1 ise döngüden çikilir.
	BGT addNewNode            ;degilse yeni node ekliyoruz.


addNewNode
	LDR r8,[r1,r4,LSL#2]	;Parent root node = r8
	
	LDR r7,[r0]				;bir sonraki node	
	STR r7,[r1,r3,LSL#2]    ;Bu nodedeki deger heape yaziliyor.

	MLA r5,r4,r6,r6         ;(Node Sayisi x 2)+2 = r5 atamasi yapilir.
	
	CMP r5,r3				; r5 deki kadar node varsa parent bir sonrakine devrediyor.
	ADDEQ r4,r4,#1			
	
	
	MOV r9,r4				; r3 ve r4 deki indexler daha sonra kullanilmak için r9 ve r11 e tasiniyor -temp deger.
	MOV r11,r3				
	CMP r3,#1
	BNE nodeControl			; Heapte tek eleman varsa dogrudan kontrole gider.
	


	ADD r3,r3,#1 			; Node counteri artar.
	B initMinHeap 			; Node ekleme islemi bitince yeni bir ekleme islemi icin operasyonun basina döner.
	
nodeControl

	LDR r12,[r1,r11,LSL#2]	; Parent ve current node kullanilmak icin r12 ve r10 registerlerine atanir. -temp deger.
	LDR r10,[r1,r9,LSL#2]			
		
	
	CMP r10,r12				
	BGT	swap	 	 ;Parent'in childdan büyük olmasi durumunda swap islemine dallanir.
	ADD r3,r3,#1 			 
	B initMinHeap 
	
swap 				 ;Parent child swap islemini gerceklestiren fonksiyon.
	
	STR r12,[r1,r9,LSL#2]	; temp degerler kullanilarak swap islemi.
	STR r10,[r1,r11,LSL#2]	
	
	CMP	r9,#1				;Parent nodemiz 1.node ise bir üst dallanma yapamaycagindan alttaki kontrollere gerek yoktur.
	ADDEQ r3,r3,#1 			
	BEQ initMinHeap 
	
	MOV r11,r9				; Ust dal kontrolu için current node = parent olur.
	AND r5,r9,#1	
	CMP r5,#0
	BEQ evenIndex
    SUBS r9,r9,#1	
	LSR  r9,r9,#1			; eskiden child olan yeni Parentimiz = Parent-1 / 2
	B nodeControl
	
	
evenIndex	    
	CMP  r9,#1				;Parent nodemiz 1.node ise bir üst dallanma yapamaycagindan alttaki kontrollere gerek yoktur.
	BEQ nodeControl			
	LSR  r9,r9,#1			;cift sayi indexli parent nodelar icin = Parent / 2
	B nodeControl

finishBuild





startSorting
	LDR r3,=myArray
	LDR r0,[r3]				; r0 = Arreymizin ilk elemani yani size.
	
	MOV r3,#2	; r3 = loop icin kullanacagimiz index
	MOV r4,#2	; r4 = O döngüdeki bulunacak en kücük elemanin atanacagi index.
	
controlMinValue
	ADD r3,r3,#1
	
	LDR r5,[r1,r3,LSL#2] ; r5 ve r6 ya dizideki anlik eleman ve karsilastirilacak kücük eleman atanir.
	LDR r6,[r1,r4,LSL#2] 	
	CMP r5,r6			 ; Indexdeki deger daha kücükse swap gerekir.
	BLT swapping
	
continueSort                
	CMP r3,r0			 ; Bir turluk dongünün sonuna gelinmesi.
	BEQ goStartFromNext			 
	B controlMinValue
	
goStartFromNext 				 ;r4 indexi bir arttirilir ve tekrar döngü basa sarilir.
    ADD r4,r4,#1
	MOV r3,r4
	CMP r4,r0
	BEQ finishSort
	B controlMinValue
swapping
	STR r5,[r1,r4,LSL#2]	; Indexdeki deger daha kücük bulundugundan r4 konumuna atanir.
	STR r6,[r1,r3,LSL#2]    ; Daha büyük olan deger ise r3 indexine atanir.
	B continueSort 


	B finishSort
finishSort

initFind
	MOV r0,#7				; r0 = Heapte bulmak istedigimiz deger.
	
	MOV r5,#0				; r5 = index degeri
searchValueInHeap
	ADD r5,r5,#1	
	LDR r6,[r1,r5,LSL#2]	
	CMP r6,r0				; r6 = Heap[r5]deki deger aradigimiz degerle karsilastirilir.
	BEQ	found
	
	CMP r5,r2               ; index size olana kadar döngü devam eder.
	BNE searchValueInHeap
	MOV r0,#0
	B finishFind	
found                ; Aranan deger bulunursa r0 a 1 atanir.
	MOV r0,#1
	B finishFind
	

finishFind
	
myArray DCD 6,9,4,8,3,7,11,-1
	END
