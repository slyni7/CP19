--코인비터 카산드라
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"FTo","H")
	e1:SetCode(EVENT_TOSS_COIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_COINBEAT_EFFECT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTR(1,1)
	e3:SetValue(s.val3)
	c:RegisterEffect(e3)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.op2(e,tp)
	local result=true
	local g=Duel.GMGroup(Card.IsControlerCanBeChanged,tp,"M",0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local sg=g:Select(tp,1,1,nil)
		Duel.GetControl(sg,1-tp,0,0)
	else
		result=false
	end
	return result
end
function s.vfil3(c,seq,rp)
	return c:IsFaceup() and c:IsSetCard("코인비터") and c:IsColumn(seq,rp,c:GetLocation()&LOCATION_ONFIELD)
end
function s.val3(e,re,tp)
	local rc=re:GetHandler()
	local rp=rc:GetControler()
	local seq=rc:GetSequence()
	return rc:IsOnField() and not Duel.IEMCard(s.vfil3,tp,"M","M",1,nil,seq,rp)
		and (rc:IsFacedown() or rc:IsLoc("M"))
end