--하이네 클라이네
local m=18452816
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","MG")
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(CARD_EINE_KLEINE)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.nfil1(c,tp)
	return c:IsFaceup() and c:IsCode(CARD_EINE_KLEINE) and c:IsAbleToHandAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SMCard(tp,cm.nfil1,tp,"M",0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0xfe0000)
	e1:SetValue(LSTN("D"))
	c:RegisterEffect(e1)
end
function cm.cfil31(c,tp)
	return c:IsCode(CARD_EINE_KLEINE) and c:IsLoc("M") and (c:IsControler(tp) or c:IsFaceup()) and c:IsCanBeFusionMaterial()
end
function cm.cfil32(c)
	return c:IsCode(CARD_EINE_KLEINE) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.tfil3(c,e,tp,m,gc,chkf)
	Auxiliary.FCheckAdditional=cm.fcheck
	Auxiliary.GCheckAdditional=cm.gcheck
	local res=c:IsType(TYPE_FUSION) and c:IsSetCard("클라이네")
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
	return res
end
function cm.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLoc,nil,"G")<2
end
function cm.gcheck(sg)
	return sg:FilterCount(Card.IsLoc,nil,"G")<2
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chkf=tp+0x100
	local g=Duel.GetReleaseGroup(tp):Filter(cm.cfil31,nil,tp)
	if c:IsHasEffect(EFFECT_EINE_KLEINE) then
		local rg=Duel.GMGroup(cm.cfil32,tp,"G",0,nil)
		g:Merge(rg)
	end
	if chk==0 then
		if e:GetLabel()~=1 then
			return false
		end
		e:GetLabel(0)
		return Duel.IEMCard(cm.tfil3,tp,"E",0,1,nil,e,tp,g,c,chkf)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SMCard(tp,cm.tfil3,tp,"E",0,1,1,nil,e,tp,g,c,chkf)
	local tc=tg:GetFirst()
	Auxiliary.FCheckAdditional=cm.fcheck
	Auxiliary.GCheckAdditional=cm.gcheck
	local mat=Duel.SelectFusionMaterial(tp,tc,g,c,chkf)
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
	local gg=mat:Filter(Card.IsLoc,nil,"G")
	mat:Sub(gg)
	if #gg>0 then
		Duel.Remove(gg,POS_FACEUP,REASON_COST)
		local te=c:IsHasEffect(EFFECT_EINE_KLEINE)
		te:UseCountLimit(tp)
	end
	Duel.Release(mat,REASON_COST)
	e:SetLabel(tc:GetCode())
end
function cm.ofil3(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local tc=Duel.GetFirstMatchingCard(cm.ofil3,tp,LSTN("E"),0,nil,e,tp,code)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end