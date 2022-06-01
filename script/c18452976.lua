--앨리스플릿
local m=18452976
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_FIRE,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.tfun1(g)
	local tc=g:GetFirst()
	local color=0
	while tc do
		local t=tc:GetSquareMana()
		for i=1,#t do
			color=t[i]|color
		end
		tc=g:GetNext()
	end
	local ct=0
	for i=0,31 do
		if color&(1<<i)>0 then
			ct=ct+1
		end
	end
	return ct
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(Card.IsFaceup,tp,"M",0,nil)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,0,0,1,RACE_PYRO,ATTRIBUTE_FIRE)
			and cm.tfun1(g)>0
	end
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(Card.IsFaceup,tp,"M",0,nil)
	local ft=Duel.GetLocCount(tp,"M")
	local ct=cm.tfun1(g)
	if ft>0 and ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,0,0,1,RACE_PYRO,ATTRIBUTE_FIRE) then
		local count=math.min(ft,ct)
		if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
			count=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		repeat
			local token=Duel.CreateToken(tp,m+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			count=count-1
		until count<1
		Duel.SpecialSummonComplete()
	end 
end