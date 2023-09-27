--내일 지구가 멸망하더라도
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function s.tfil1(c)
	local te=c:IsHasEffect(EFFECT_DELAY_TURN)
	if not te then
		return false
	end
	local val=te:GetValue()
	return c:IsSummonType(SUMMON_TYPE_DELIGHT) and (val>0 or (val==0 and Duel.GetCurrentPhase()<=PHASE_STANDBY))
		and te:GetLabel()&ELABEL_IS_DELIGHT_SUMMONING~=0
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=aux.DelayGroup[tp]:Filter(s.tfil1,nil)
	if chk==0 then
		return #sg>0
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local sg=aux.DelayGroup[tp]:FilterSelect(tp,s.tfil1,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0,fid)
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_DELAY_TURN)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetOperation(s.oop11)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=fid then
		e:Reset()
		return
	end
	if eg:IsContains(tc) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end