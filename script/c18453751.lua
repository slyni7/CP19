--사일런트 머조리티: 노닐리온
local m=18453751
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.pfil1)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TODECK)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","M")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCondition(aux.zptcon(cm.nfil2))
	WriteEff(e2,1,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.pfil1(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x2e0)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.nfil2(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x2e0)
end
function cm.tfil11(c)
	return c:IsSetCard(0x2e0) and c:IsAbleToDeck()
end
function cm.tfil12(c,m)
	local st=c:GetSquareMana()
	if not st or #st==0 then
		return false
	end
	local res=true
	for i=1,#st do
		if st[i]~=0 then
			res=false
			break
		end
	end
	if not res then
		return false
	end
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2e0) and c:CheckFusionMaterial(m,nil,PLAYER_NONE)
end
function cm.fcheck(tp,sg,fc)
	return #sg<3 and aux.dncheck(sg)
end
function cm.gcheck(sg)
	return #sg<3 and aux.dncheck(sg)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=SilentMajorityGroups[tp]:Filter(cm.tfil11,nil)
		Auxiliary.FCheckAdditional=cm.fcheck
		if Fusion then
			Fusion.CheckAdditional=cm.fcheck
		end
		Auxiliary.GCheckAdditional=cm.gcheck
		local res=SilentMajorityGroups[tp]:IsExists(cm.tfil12,1,nil,mg)
		Auxiliary.FCheckAdditional=nil
		if Fusion then
			Fusion.CheckAdditional=nil
		end
		Auxiliary.GCheckAdditional=nil
		return res
	end
	Duel.SOI(0,CATEGORY_TODECK,nil,2,tp,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg=SilentMajorityGroups[tp]:Filter(cm.tfil11,nil)
	Auxiliary.FCheckAdditional=cm.fcheck
	if Fusion then
		Fusion.CheckAdditional=cm.fcheck
	end
	Auxiliary.GCheckAdditional=cm.gcheck
	local sg=SilentMajorityGroups[tp]:Filter(cm.tfil12,nil,mg)
	if #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,PLAYER_NONE)
		Duel.SendtoDeck(mat,nil,2,REASON_EFFECT)
	end
	Auxiliary.FCheckAdditional=nil
	if Fusion then
		Fusion.CheckAdditional=nil
	end
	Auxiliary.GCheckAdditional=nil
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1500)
	end
	Duel.PayLPCost(tp,1500)
end
function cm.tfil3(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL) and c:CheckActivateEffect(true,true,false)~=nil
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		return SilentMajorityGroups[tp]:IsExists(cm.tfil3,1,nil)
	end
	local g=SilentMajorityGroups[tp]:FilterSelect(tp,cm.tfil3,1,1,nil)
	if not Duel.SendtoGrave(g,REASON_COST) then
		return
	end
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
	end
end