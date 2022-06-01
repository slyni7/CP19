--[ YUGIOH ]
local m=99970803
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.hspcon)
	c:RegisterEffect(e2)

	--"유희"
	local e0=MakeEff(c,"FC","E")
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e9=MakeEff(c,"FC","M")
	e9:SetCategory(CATEGORY_REMOVE)
	e9:SetCode(EVENT_ADJUST)
	WriteEff(e9,9,"O")
	c:RegisterEffect(e9)
	local e89=MakeEff(c,"F","M")
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_PUBLIC)
	e8:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e8)
	
end

--융합 소환
function cm.ffilter(c)
	return c:IsPublic()
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(nil,tp,LSTN("OH"),LSTN("OH"),nil)
	local ct=#g:Filter(Card.IsPublic,nil)
	return (#g-ct)>=ct and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

--"유희"
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local tc=nil
	local check=false
	local ac=0
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		for i=1,Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			ac=Duel.AnnounceCard(1-tp)
			tc=Duel.GetFirstMatchingCard(Card.IsSequence,1-tp,LOCATION_DECK,0,nil,i-1)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			if tc:GetCode()~=ac then check=true end
		end
		if check then
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-2000)
		else
			Duel.SetLP(tp,Duel.GetLP(tp)-1000)
		end
	end
end
function cm.op9fil(c,t)
	return c:IsType(t) and c:IsAbleToRemove()
end
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(1-tp) or Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)==0 then return end
	local hand=Duel.GetMatchingGroup(Card.IsPublic,tp,0,LOCATION_HAND,nil)
	local mc=hand:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount()
	local sc=hand:Filter(Card.IsType,nil,TYPE_SPELL):GetCount()
	local tc=hand:Filter(Card.IsType,nil,TYPE_TRAP):GetCount()
	local mi=math.min(mc,sc,tc)
	local g=Group.CreateGroup()
	if mi==mc then
		g:Merge(Duel.GetMatchingGroup(cm.op9fil,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,TYPE_MONSTER))
	end
	if mi==sc then
		g:Merge(Duel.GetMatchingGroup(cm.op9fil,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,TYPE_SPELL))
	end
	if mi==tc then
		g:Merge(Duel.GetMatchingGroup(cm.op9fil,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,TYPE_TRAP))
	end
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_RULE)
	end
end
