--도로보네코 일레븐
local m=18453144
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","G")
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(cm.con3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.tfil21(c,tp)
	return c:IsSetCard(0x2e4) and c:IsType(TYPE_MONSTER) and c:IsSSetable(true)
		and not Duel.IEMCard(cm.tfil22,tp,"OG",0,1,nil,c:GetCode())
end
function cm.tfil22(c,code)
	return (c:IsFaceup() or c:IsLoc("G")) and c:IsCode(code)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLoc("S") and c:IsFacedown() and c:GetType()==TYPE_SPELL
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0 and Duel.IEMCard(cm.tfil21,tp,"E",0,1,nil,tp)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,cm.tfil21,tp,"E",0,1,1,nil,tp)
	if #g>0 then
		local tc=g:GetFirst()
		if not IREDO_COMES_TRUE then
			tc:Type(TYPE_MONSTER+TYPE_EFFECT)
		end
		Duel.SSet(tp,tc)
		if not IREDO_COMES_TRUE then
			tc:Type(TYPE_MONSTER+TYPE_EFFECT+TYPE_LINK)
		end
	end
end
function cm.nfil3(c,tp)
	return c:IsSetCard(0x2e4) and c:IsSSetable(true) and c:IsFaceup() and not c:IsCode(m) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.con3(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IEMCard(cm.nfil3,tp,"M",0,1,nil,tp) and Duel.GetLocCount(tp,"S")>0
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,cm.nfil3,tp,"M",0,1,1,nil,tp)
	local tc=g:GetFirst()
	Duel.SSet(tp,tc)
end