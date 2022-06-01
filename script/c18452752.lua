--¸á¶ûÈ¦¸¯: ¸»°ý·®ÀÌ ³¶¸¸°í¾çÀÌ
local m=18452752
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=MakeEff(c,"I","HG")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(m)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTR(1,1)
	c:RegisterEffect(e3)
end
function cm.cfil1(c)
	return c:IsSetCard(0x2d3) and c:IsDiscardable()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if Duel.CheckPhaseActivity() then
			e:SetLabel(0)
		else
			e:SetLabel(100)
		end
		return e:GetLabel()==100 or Duel.IEMCard(cm.cfil1,tp,"H",0,1,c)
	end
	if e:GetLabel()~=100 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SMCard(tp,cm.cfil1,tp,"H",0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.tfil2(c,tp)
	return c:IsSetCard(0x2d3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
		and (c:IsType(TYPE_FIELD) or Duel.GetLocCount(tp,"S")>0)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil,tp)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,r,p)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil,tp)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end