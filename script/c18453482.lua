--과거융합-패스트 퓨전
local m=18453482
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil1(c,e,tp)
	return c:IsType(TYPE_FUSION) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"E",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"E",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,fid)
		if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			local e1=MakeEff(c,"SC")
			e1:SetCode(EVENT_TO_GRAVE)
			e1:SetReset(RESET_CHAIN+RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_LEAVE)
			e1:SetLabelObject(tc)
			e1:SetLabel(fid)
			e1:SetOperation(cm.oop11)
			c:RegisterEffect(e1)
			local e2=MakeEff(c,"S")
			e2:SetCode(EFFECT_DISABLE)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetCondition(cm.ocon12)
			tc:RegisterEffect(e2)
			local e3=MakeEff(c,"S")
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetCondition(cm.ocon12)
			tc:RegisterEffect(e3)
			local e4=MakeEff(c,"S")
			e4:SetCode(EFFECT_CANNOT_ATTACK)
			e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetCondition(cm.ocon12)
			tc:RegisterEffect(e4)
			local e5=MakeEff(c,"FC")
			e5:SetCode(EVENT_ADJUST)
			e5:SetLabelObject(tc)
			e5:SetLabel(fid)
			e5:SetCondition(cm.ocon15)
			e5:SetOperation(cm.oop15)
			Duel.RegisterEffect(e5,tp)
		end
	end
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if r==REASON_RULE and re==nil then
		local e1=MakeEff(c,"Qo","G")
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetLabelObject(e:GetLabelObject())
		e1:SetLabel(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(cm.oocon111)
		e1:SetCost(aux.bfgcost)
		e1:SetTarget(cm.ootar111)
		e1:SetOperation(cm.ooop111)
		c:RegisterEffect(e1)
	end
end
function cm.oocon111(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if tc:GetFlagEffectLabel(m)~=fid then
		e:Reset()
		return false
	end
	return true
end
function cm.ootfil111(c)
	return c:IsAbleToGrave()
end
function cm.ootar111(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if chk==0 then
		local g=Duel.GMGroup(cm.ootfil111,tp,"HO",0,nil)
		return tc:CheckFusionMaterial(g,nil,PLAYER_NONE)
	end
	if tc:GetFlagEffectLabel(m)~=fid then
		return
	end
end
function cm.ooop111(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if tc:GetFlagEffectLabel(m)~=fid then
		return
	end
	local g=Duel.GMGroup(cm.ootfil111,tp,"HO",0,nil)
	local sg=Duel.SelectFusionMaterial(tp,tc,g,nil,PLAYER_NONE)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function cm.nfil12(c)
	return c:IsLoc("G") or c:IsFaceup()
end
function cm.ocon12(e)
	local tc=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local g=Duel.GMGroup(cm.nfil12,tp,"OG",0,nil)
	return not tc:CheckFusionMaterial(g,nil,PLAYER_NONE)
end
function cm.ocon15(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	return tc:GetFlagEffectLabel(m)~=fid
end
function cm.oop15(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.GMGroup(cm.nfil12,tp,"OG",0,nil)
	if not tc:CheckFusionMaterial(g,nil,PLAYER_NONE) then
		Duel.Hint(HINT_CARD,0,m)
		local mg=Duel.GMGroup(cm.ootfil111,tp,"HO",0,nil)
		local dg=Duel.GMGroup(Card.IsAbleToDeck,tp,"HO",0,nil)
		local b1=tc:CheckFusionMaterial(mg,nil,PLAYER_NONE)
		local b2=#dg>0
		local op=aux.SelectEffect(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)})
		if op==1 then
			local sg=Duel.SelectFusionMaterial(tp,tc,mg,nil,PLAYER_NONE)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		elseif op==2 then
			Duel.SendtoDeck(dg,nil,2,REASON_RULE)
		end
	end
	e:Reset()
end