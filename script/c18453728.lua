--셰라자드
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if p~=ep then
			Duel.SetLP(p,math.ceil(Duel.GetLP(p)/2))
		end
	end
	e:Reset()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(id)
	e1:SetCL(1)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetOperation(s.oop11)
	Duel.RegisterEffect(e1,0)
	local t1={}
	local seq=0
	local tc=Duel.GetFieldCard(0,LOCATION_DECK,seq)
	while tc do
		table.insert(t1,tc:GetOriginalCode())
		seq=seq+1
		tc=Duel.GetFieldCard(0,LOCATION_DECK,seq)
	end
	local t2={}
	local seq=0
	local tc=Duel.GetFieldCard(0,LOCATION_EXTRA,seq)
	while tc do
		table.insert(t2,tc:GetOriginalCode())
		seq=seq+1
		tc=Duel.GetFieldCard(0,LOCATION_EXTRA,seq)
	end
	local t3={}
	local seq=0
	local tc=Duel.GetFieldCard(1,LOCATION_DECK,seq)
	while tc do
		table.insert(t3,tc:GetOriginalCode())
		seq=seq+1
		tc=Duel.GetFieldCard(1,LOCATION_DECK,seq)
	end
	local t4={}
	local seq=0
	local tc=Duel.GetFieldCard(1,LOCATION_EXTRA,seq)
	while tc do
		table.insert(t4,tc:GetOriginalCode())
		seq=seq+1
		tc=Duel.GetFieldCard(1,LOCATION_EXTRA,seq)
	end
	local fp=Duel.RockPaperScissors()
	local b=Duel.SelectOption(fp,aux.Stringid(id,0),aux.Stringid(id,1))
	if b==1 then
		fp=1-fp
	end
	Debug.Shahrazad(t1,t2,t3,t4,fp)
end