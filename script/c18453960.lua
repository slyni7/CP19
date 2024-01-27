--이상물질(아이딜 매터) 「청룡」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,id)
	local e1=MakeEff(c,"F","E")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetTR(0,"M")
	e3:SetValue(s.val3)
	c:RegisterEffect(e3)
end
function s.nfil1(c,tp)
	return c:IsCode(18453971) and c:IsFaceup() and c:IsReleasable()
		and Duel.GetMZoneCount(tp,c)>0
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IEMCard(s.nfil1,tp,"O",0,1,nil,tp)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SMCard(tp,s.nfil1,tp,"O",0,0,1,nil,tp)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function s.val3(e,c)
	local handler=e:GetHandler()
	return c~=handler and c:IsSetCard("이상물질(아이딜 매터)")
end